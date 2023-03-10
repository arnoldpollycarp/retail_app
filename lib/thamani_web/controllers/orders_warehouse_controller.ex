defmodule ThamaniWeb.OrdersWarehouseController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Warehouse_orders
  alias Thamani.Inventories
  alias Thamani.Warehouse_orders.Warehouse_order
  alias Thamani.Dispatches
  alias Thamani.Repo

  plug(:put_layout, "warehouse.html")
  plug(:scrub_params, "warehouse_order" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user
    warehouse_order = Warehouse_orders.list_orders_warehouse(current_user.id)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    if warehouse_order do
      render(
        conn,
        "index.html",
        warehouse_order: warehouse_order,
        user: user,
        count_7: count_7,
        count_order: count_order,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: orders_warehouse_path(conn, :index))
    end
  end

  def new(conn, _params, _current_user) do
    conn
    |> put_flash(:error, "Not authorised to add to this page")
    |> redirect(to: orders_warehouse_path(conn, :index))
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)
    warehouse_order = Warehouse_orders.get_orders_warehouse(current_user.id, id)

    if warehouse_order do
      render(
        conn,
        "show.html",
        warehouse_order: warehouse_order,
        user: user,
        count_7: count_7,
        count_order: count_order,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: orders_warehouse_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    warehouse_order = Warehouse_orders.get_orders_warehouse(current_user.id, id)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    if warehouse_order do
      changeset = Warehouse_order.changeset(warehouse_order, %{})

      render(
        conn,
        "edit.html",
        warehouse_order: warehouse_order,
        changeset: changeset,
        count_7: count_7,
        count_order: count_order,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to edit this page")
      |> redirect(to: orders_warehouse_path(conn, :index))
    end
  end

  def update(
        conn,
        %{"id" => id, "warehouse_order" => warehouse_orders_params},
        current_user
      ) do
    warehouse_order = Warehouse_orders.get_orders_warehouse(current_user.id, id)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)
    changeset = Warehouse_order.changeset(warehouse_order, warehouse_orders_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "order updated successfully.")
        |> redirect(to: orders_warehouse_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          warehouse_order: warehouse_order,
          changeset: changeset,
          count_7: count_7,
          count_order: count_order,
          count_stock: count_stock
        )
    end
  end
end
