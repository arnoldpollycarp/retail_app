defmodule ThamaniWeb.SalesManufacturerController do
  use ThamaniWeb, :controller
  import Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Sales.Sale
  alias Thamani.Sales
  alias Thamani.Inventories
  alias Thamani.Accounts.User
  alias Thamani.Retail_Returns
  alias Thamani.Returns
  alias Thamani.Manufacturer_orders
  alias Thamani.Retman_orders
  alias Thamani.Repo

  plug(:put_layout, "manufacturer.html")

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, params, current_user) do
    user = User |> Repo.get_by!(id: current_user.id)

    {query, rummage} =
      Sale
      |> where([q], q.mid == ^current_user.id)
      |> Sale.rummage(params["rummage"])

    sales =
      query
      |> where([q], q.mid == ^current_user.id)
      |> Repo.all()
      |> Repo.preload(:sku)
      |> Repo.preload(:user)

    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order_all()
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    if sales do
      render(
        conn,
        "index.html",
        sales: sales,
        rummage: rummage,
        user: user,
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return: count_return,
        count_return_retail: count_return_retail
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: sales_manufacturer_path(conn, :index))
    end
  end

  def new(conn, _params, _current_user) do
    conn
    |> put_flash(:error, "Not authorised to add to this page")
    |> redirect(to: sales_manufacturer_path(conn, :index))
  end

  def show(conn, %{"id" => id}, current_user) do
    user = User |> Repo.get_by!(id: current_user.id)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order_all()
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)
    sales = Sales.get_sale_manufacturer(current_user.id, id)

    if sales do
      render(
        conn,
        "show.html",
        sales: sales,
        user: user,
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return: count_return,
        count_return_retail: count_return_retail
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: sales_manufacturer_path(conn, :index))
    end
  end
end
