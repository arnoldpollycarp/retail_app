defmodule ThamaniWeb.OrdersManufacturerController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Manufacturer_orders
  alias Thamani.Inventories
  alias Thamani.Manufacturer_orders.Manufacturer_order
  alias Thamani.Retman_orders
  alias Thamani.Retail_Returns
  alias Thamani.Returns
  alias Thamani.Repo

  plug(:put_layout, "manufacturer.html")
  plug(:scrub_params, "manufacturer_order" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user
    manufacturer_order = Manufacturer_orders.list_orders_manufacturer(current_user.id)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    if manufacturer_order do
      render(
        conn,
        "index.html",
        manufacturer_order: manufacturer_order,
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
      |> redirect(to: orders_manufacturer_path(conn, :index))
    end
  end

  def new(conn, _params, _current_user) do
    conn
    |> put_flash(:error, "Not authorised to add to this page")
    |> redirect(to: orders_manufacturer_path(conn, :index))
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)
    manufacturer_order = Manufacturer_orders.get_orders_manufacturer(current_user.id, id)
    count_order_retman = Retman_orders.get_count_order(current_user)

    if manufacturer_order do
      render(
        conn,
        "show.html",
        manufacturer_order: manufacturer_order,
        count_order_retman: count_order_retman,
        user: user,
        count_stock: count_stock,
        count_order: count_order,
        count_return: count_return,
        count_return_retail: count_return_retail
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: orders_manufacturer_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    manufacturer_order = Manufacturer_orders.get_orders_manufacturer(current_user.id, id)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    if manufacturer_order do
      changeset = Manufacturer_order.changeset(manufacturer_order, %{})

      render(
        conn,
        "edit.html",
        manufacturer_order: manufacturer_order,
        count_order_retman: count_order_retman,
        changeset: changeset,
        count_stock: count_stock,
        count_order: count_order,
        count_return: count_return,
        count_return_retail: count_return_retail
      )
    else
      conn
      |> put_flash(:error, "Not authorised to edit this page")
      |> redirect(to: orders_manufacturer_path(conn, :index))
    end
  end

  def update(
        conn,
        %{"id" => id, "manufacturer_order" => manufacturer_orders_params},
        current_user
      ) do
    manufacturer_order = Manufacturer_orders.get_orders_manufacturer(current_user.id, id)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    changeset = Manufacturer_order.changeset(manufacturer_order, manufacturer_orders_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "order updated successfully.")
        |> redirect(to: orders_manufacturer_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          manufacturer_order: manufacturer_order,
          changeset: changeset,
          count_stock: count_stock,
          count_order: count_order,
          count_return: count_return,
          count_return_retail: count_return_retail,
          count_order_retman: count_order_retman
        )
    end
  end
end
