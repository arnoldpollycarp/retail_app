defmodule ThamaniWeb.SaleController do
  use ThamaniWeb, :controller
  import Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Dispatches
  alias Thamani.Inventories
  alias Thamani.Sales
  alias Thamani.Sales.Sale
  alias Thamani.Accounts.User
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches_Retailer
  alias Thamani.Dispatches
  alias Thamani.Repo

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "sale" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, params, current_user) do
    user = User |> Repo.get_by!(id: current_user.id)

    {query, rummage} =
      Sale
      |> where([q], q.user_id == ^current_user.id)
      |> Sale.rummage(params["rummage"])

    sale =
      query
      |> where([q], q.user_id == ^current_user.id)
      |> Repo.all()
      |> Repo.preload(:sku)
      |> Repo.preload(:user)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    render(
      conn,
      "index.html",
      sale: sale,
      rummage: rummage,
      user: user,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6
    )
  end

  def create(
        conn,
        %{"sale" => %{"item" => item, "quantity" => quantity, "mode" => mode}},
        current_user
      ) do
    bat = Sales.get_items(current_user)
    price_1 = Dispatches.get_price(item)
    price_2 = Inventories.get_price(item, current_user)
    mid = Sales.get_item_manufacturer(item)
    wid = Sales.get_item_warehouse!(item, current_user)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    changeset =
      current_user
      |> Ecto.build_assoc(:sales)
      |> Sale.changeset(%{
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
        "gs1" => String.to_integer(Enum.join([quantity])) * 10
      })

    qty = Sales.get_count_quantity_item!(current_user, item)
    qty_rec = Dispatches_Warehouse.get_count_quantity_item_retail(current_user, item)

    available = Dispatches.to_integer(qty_rec) - Dispatches.to_integer(qty)

    if Dispatches.to_integer(quantity) <= available do
      case Repo.insert(changeset) do
        {:ok, _} ->
          conn
          |> put_flash(:info, "sale created successfully.")
          |> redirect(to: sale_path(conn, :index))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(
            conn,
            "new.html",
            changeset: changeset,
            bat: bat,
            count_4: count_4,
            count_5: count_5,
            count_6: count_6
          )
      end
    else
      conn
      |> put_flash(
        :error,
        "You have exceeded the quantity limit. Available quantity  is #{available} "
      )
      |> render(
        "new.html",
        changeset: changeset,
        bat: bat,
        count_4: count_4,
        count_5: count_5,
        count_6: count_6
      )
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}, current_user) do
    user = User |> Repo.get_by!(id: current_user.id)

    sale =
      user
      |> user_sale_by_id(current_user.id)
      |> Repo.preload(:sku)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    if sale do
      render(
        conn,
        "show.html",
        sale: sale,
        user: user,
        count_4: count_4,
        count_5: count_5,
        count_6: count_6
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: sale_path(conn, :index))
    end
  end

  defp user_sale(user) do
    Ecto.assoc(user, :sales)
  end

  defp user_sale_by_id(user, id) do
    user
    |> user_sale
    |> Repo.get(id)
  end
end
