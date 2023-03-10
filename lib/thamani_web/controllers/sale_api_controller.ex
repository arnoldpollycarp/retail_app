defmodule ThamaniWeb.SaleApiController do
  use ThamaniWeb, :controller
  alias ThamaniWeb.ErrorView
  alias Plug.Conn

  alias Thamani.Dispatches
  alias Thamani.Sales
  alias Thamani.Sales.Sale
  alias Thamani.Inventories
  alias Thamani.Repo

  def index(conn, %{"user_id" => user_id}) do
    sales = Sales.list_sales_by_user(user_id)
    render(conn, "index.json", sales: sales)
  end

  def create(conn, %{
        "sale" => sale_params,
        "mode" => mode,
        "serial" => serial,
        "user_id" => user_id,
        "staff_id" => staff_id,
        "imei" => imei,
        "retailer_name" => retailer_name
      }) do
    date = String.slice(to_string(DateTime.utc_now()), 0..9)

    list =
      Enum.map(sale_params, fn x ->
        Enum.into(x, %{
          "mode" => mode,
          "user_id" => user_id,
          "staff" => staff_id,
          "date" => date,
          "sale_id" => serial,
          "imei" => imei,
          "retailer_name" => retailer_name
        })
      end)

    changesets =
      Enum.map(list, fn sale ->
        Sale.changeset(%Sale{}, sale)
      end)

    result =
      changesets
      |> Enum.with_index()
      |> Enum.reduce(Ecto.Multi.new(), fn {changeset, index}, multi ->
        Ecto.Multi.insert(multi, Integer.to_string(index), changeset)
      end)
      |> Repo.transaction()

    case result do
      {:ok, multi_sale_result} ->
        render(conn, "index.json", sales: Map.values(multi_sale_result), error: true)

      {:error, _, changeset, _} ->
        render(conn, ErrorView, "422.json", changeset: changeset, error: false)
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    if sale = Sales.get_sale_by_user!(user_id, id) do
      render(conn, "show.json", sale: sale)
    else
      conn
      |> put_status(404)
      |> render(ErrorView, "404.json", error: "Not found")
    end
  end

  def update(
        conn,
        %{"id" => id} = %{
          "item" => item,
          "quantity" => quantity,
          "mode" => mode,
          "user_id" => user_id
        }
      ) do
    sales = Repo.get(Sale, id)
    price_1 = Dispatches.get_price(item)
    price_2 = Inventories.get_price!(item, user_id)
    mid = Sales.get_item_manufacturer(item)
    wid = Sales.get_item_warehouse!(item, user_id)

    changeset =
      Sale.changeset(sales, %{
        "item" => item,
        "quantity" => quantity,
        "mode" => mode,
        "manufacturer" =>
          String.to_integer(Enum.join([quantity])) * Dispatches.to_integer(price_1),
        "mid" => mid,
        "warehouse" => 0.5 * String.to_integer(Enum.join([quantity])),
        "wid" => wid,
        "retailer" =>
          String.to_integer(Enum.join([quantity])) * String.to_integer(Enum.join(price_2)),
        "gs1" => String.to_integer(Enum.join([quantity])) * 10,
        "user_id" => user_id
      })

    with {:ok, sale} <- Repo.update(changeset) do
      render(conn, "show.json", data: sale)
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
    end
  end

  def delete(conn, %{"id" => id}) do
    with sale = %Sale{} <- Repo.get(Sale, id) do
      Sales.delete_sale(sale)

      conn
      |> Conn.put_status(204)
      |> Conn.send_resp(:no_content, "")
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
    end
  end
end
