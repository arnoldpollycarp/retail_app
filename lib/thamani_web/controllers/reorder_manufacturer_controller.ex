defmodule ThamaniWeb.ReorderManufacturerController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Retman_orders
  alias Thamani.Manufacturer_orders
  alias Thamani.Inventories
  alias Thamani.Returns
  alias Thamani.Retail_Returns
  alias Thamani.Reorders
  alias Thamani.Reorders.Reorder
  alias Thamani.Repo

  plug(:put_layout, "manufacturer.html")
  plug(:scrub_params, "reorder" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user
    received = Reorders.list_recieved_man(current_user.id)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    if received do
      render(
        conn,
        "index.html",
        received: received,
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
      |> redirect(to: reorder_manufacturer_path(conn, :index))
    end
  end

  def new(conn, _params, _current_user) do
    conn
    |> put_flash(:error, "Not authorised to add to this page")
    |> redirect(to: reorder_manufacturer_path(conn, :index))
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user
    received = Reorders.get_recieved_man(current_user.id, id)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    if received do
      render(
        conn,
        "show.html",
        received: received,
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
      |> redirect(to: reorder_manufacturer_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    received = Reorders.get_recieved_man(current_user.id, id)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    if received do
      changeset = Reorder.changeset(received, %{})

      render(
        conn,
        "edit.html",
        received: received,
        changeset: changeset,
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return: count_return,
        count_return_retail: count_return_retail
      )
    else
      conn
      |> put_flash(:error, "Not authorised to edit this page")
      |> redirect(to: reorder_manufacturer_path(conn, :index))
    end
  end

  def update(
        conn,
        %{"id" => id, "reorder" => received_params},
        current_user
      ) do
    received = Reorders.get_recieved_man(current_user.id, id)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)
    changeset = Reorder.changeset(received, received_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "reorder updated successfully.")
        |> redirect(to: reorder_manufacturer_path(conn, :inde))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          received: received,
          changeset: changeset,
          count_stock: count_stock,
          count_order: count_order,
          count_order_retman: count_order_retman,
          count_return: count_return,
          count_return_retail: count_return_retail
        )
    end
  end
end
