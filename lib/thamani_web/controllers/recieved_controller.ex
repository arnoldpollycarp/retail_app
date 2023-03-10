defmodule ThamaniWeb.RecievedController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Dispatches
  alias Thamani.Dispatches.Dispatch
  alias Thamani.Inventories
  alias Thamani.Warehouse_orders
  alias Thamani.Repo

  plug(:put_layout, "warehouse.html")
  plug(:scrub_params, "dispatch" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user
    recieved = Dispatches.list_recieved(current_user.id)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    if recieved do
      render(
        conn,
        "index.html",
        recieved: recieved,
        user: user,
        count_7: count_7,
        count_order: count_order,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: recieved_path(conn, :index))
    end
  end

  def new(conn, _params, _current_user) do
    conn
    |> put_flash(:error, "Not authorised to add to this page")
    |> redirect(to: recieved_path(conn, :index))
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user
    recieved = Dispatches.get_recieved(current_user.id, id)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    if recieved do
      render(
        conn,
        "show.html",
        recieved: recieved,
        user: user,
        count_7: count_7,
        count_order: count_order,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: recieved_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    recieved = Dispatches.get_recieved(current_user.id, id)
    bat = Dispatches.get_items(current_user)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)
    company = Dispatches.get_company()

    if recieved do
      changeset = Dispatch.changeset(recieved, %{})

      render(
        conn,
        "edit.html",
        recieved: recieved,
        changeset: changeset,
        bat: bat,
        company: company,
        count_7: count_7,
        count_order: count_order,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to edit this page")
      |> redirect(to: recieved_path(conn, :index))
    end
  end

  def update(
        conn,
        %{"id" => id, "dispatch" => recieved_params},
        current_user
      ) do
    recieved = Dispatches.get_recieved(current_user.id, id)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)
    changeset = Dispatch.changeset(recieved, recieved_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "recieved updated successfully.")
        |> redirect(to: recieved_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          recieved: recieved,
          changeset: changeset,
          count_7: count_7,
          count_order: count_order,
          count_stock: count_stock
        )
    end
  end
end
