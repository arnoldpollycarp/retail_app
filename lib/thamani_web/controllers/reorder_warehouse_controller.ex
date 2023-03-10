defmodule ThamaniWeb.ReorderWarehouseController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Dispatches
  alias Thamani.Warehouse_orders
  alias Thamani.Reorders
  alias Thamani.Reorders.Reorder
  alias Thamani.Inventories
  alias Thamani.Repo

  plug(:put_layout, "warehouse.html")
  plug(:scrub_params, "reorder" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user
    received = Reorders.list_recieved(current_user.id)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    if received do
      render(
        conn,
        "index.html",
        received: received,
        user: user,
        count_7: count_7,
        count_order: count_order,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: reorder_warehouse_path(conn, :index))
    end
  end

  def new(conn, _params, _current_user) do
    conn
    |> put_flash(:error, "Not authorised to add to this page")
    |> redirect(to: reorder_warehouse_path(conn, :index))
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user
    received = Reorders.get_recieved(current_user.id, id)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    if received do
      render(
        conn,
        "show.html",
        received: received,
        user: user,
        count_7: count_7,
        count_order: count_order,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: reorder_warehouse_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    received = Reorders.get_recieved(current_user.id, id)

    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    if received do
      changeset = Reorder.changeset(received, %{})

      render(
        conn,
        "edit.html",
        received: received,
        changeset: changeset,
        count_7: count_7,
        count_order: count_order,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to edit this page")
      |> redirect(to: reorder_warehouse_path(conn, :index))
    end
  end

  def update(
        conn,
        %{"id" => id, "reorder" => received_params},
        current_user
      ) do
    received = Reorders.get_recieved(current_user.id, id)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)
    changeset = Reorder.changeset(received, received_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "recieved updated successfully.")
        |> redirect(to: reorder_warehouse_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          received: received,
          changeset: changeset,
          count_7: count_7,
          count_order: count_order,
          count_stock: count_stock
        )
    end
  end
end
