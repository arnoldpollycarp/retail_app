defmodule ThamaniWeb.SalesWarehouseController do
  use ThamaniWeb, :controller
  import Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Sales
  alias Thamani.Sales.Sale
  alias Thamani.Inventories
  alias Thamani.Dispatches
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Accounts.User
  alias Thamani.Warehouse_orders

  alias Thamani.Items

  alias Thamani.Repo

  plug(:put_layout, "warehouse.html")

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, params, current_user) do
    user = User |> Repo.get_by!(id: current_user.id)

    {query, rummage} =
      Sale
      |> where([q], q.wid == ^current_user.id)
      |> Sale.rummage(params["rummage"])

    sales =
      query
      |> where([q], q.wid == ^current_user.id)
      |> Repo.all()
      |> Repo.preload(:sku)
      |> Repo.preload(:user)

    count_stock = Inventories.get_count_restock_warehouse(current_user)
    count_1 = Items.get_count_sku(current_user)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_3 = Dispatches_Warehouse.get_count_dispatch(current_user)
    count_4 = Dispatches_Warehouse.get_count_quantity(current_user)
    count_5 = Dispatches_Warehouse.get_count_confirmed(current_user)

    count_7 = Dispatches.get_count_recieved!(current_user.id)

    if sales do
      render(
        conn,
        "index.html",
        sales: sales,
        rummage: rummage,
        user: user,
        count_stock: count_stock,
        count_order: count_order,
        count_1: count_1,
        count_3: count_3,
        count_4: count_4,
        count_5: count_5,
        count_7: count_7
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: sales_warehouse_path(conn, :index))
    end
  end

  def new(conn, _params, _current_user) do
    conn
    |> put_flash(:error, "Not authorised to add to this page")
    |> redirect(to: sales_warehouse_path(conn, :index))
  end

  def show(conn, %{"sale_id" => mid, "id" => id}, current_user) do
    user = User |> Repo.get_by!(id: mid)
    count_stock = Inventories.get_count_restock_warehouse(current_user)
    count_1 = Items.get_count_sku(current_user)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_3 = Dispatches_Warehouse.get_count_dispatch(current_user)
    count_4 = Dispatches_Warehouse.get_count_quantity(current_user)
    count_5 = Dispatches_Warehouse.get_count_confirmed(current_user)

    count_7 = Dispatches.get_count_recieved!(current_user.id)
    sale = Sales.get_sale_by_user!(mid, id)

    if sale do
      render(
        conn,
        "show.html",
        sale: sale,
        user: user,
        count_stock: count_stock,
        count_order: count_order,
        count_1: count_1,
        count_3: count_3,
        count_4: count_4,
        count_5: count_5,
        count_7: count_7
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: sales_warehouse_path(conn, :index))
    end
  end
end
