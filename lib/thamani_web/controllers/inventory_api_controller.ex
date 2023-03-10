defmodule ThamaniWeb.InventoryApiController do
  use ThamaniWeb, :controller
  alias ThamaniWeb.ErrorView
  alias Plug.Conn

  alias Thamani.Sales

  alias Thamani.Inventories
  alias Thamani.Inventories.Inventory

  alias Thamani.Repo

  def index(conn, %{"security_key" => security_key, "user_id" => user_id}) do
    if security_key == Application.get_env(:mpesa_elixir, :keylock) do
      inventorys = Inventories.list_inventories!(user_id)
      render(conn, "index.json", inventorys: inventorys)
    else
      conn
      |> put_status(404)
      |> render(ErrorView, "404.json", error: "Not found")
    end
  end

  def create(conn, %{
        "item" => item,
        "price" => price,
        "category" => category,
        "description" => description,
        "active" => active,
        "user_id" => user_id
      }) do
    mid = Sales.get_item_manufacturer(item)

    changeset =
      Inventory.changeset(%Inventory{}, %{
        "item" => item,
        "mid" => mid,
        "price" => price,
        "category" => category,
        "description" => description,
        "active" => active,
        "user_id" => user_id
      })

    with {:ok, inventory} <- Repo.insert(changeset) do
      conn
      |> Conn.put_status(201)
      |> render("show.json", inventory: inventory)
    else
      {:error, %{errors: errors}} ->
        conn
        |> put_status(422)
        |> render(ErrorView, "422.json", %{errors: errors})
    end
  end

  def show(conn, %{"security_key" => security_key, "user_id" => user_id, "id" => id}) do
    if security_key == Application.get_env(:mpesa_elixir, :keylock) do
      inventory = Inventories.get_inventory_by_gtin(id, user_id)
      one = Decimal.to_integer(Inventories.get_item_count_quantity_pos(id, user_id))
      two = Decimal.to_integer(Sales.get_count_quantity_item_pos(user_id,id))


        if (one  - two) > 0 do
          render(conn, "show.json", inventory: inventory)
        else
          render(ErrorView, "404.json", error: "Not found")
        end
    else
      conn
      |> put_status(404)
      |> render(ErrorView, "404.json", error: "Not found")
    end
  end

  def update(conn, %{"id" => id} = params) do
    inventories = Repo.get(Inventory, id)
    changeset = Inventory.changeset(inventories, params)

    with {:ok, inventory} <- Repo.update(changeset) do
      render(conn, "show.json", data: inventory)
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
    end
  end

  def delete(conn, %{"id" => id}) do
    with inventory = %Inventory{} <- Repo.get(Inventory, id) do
      Inventories.delete_inventory(inventory)

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
