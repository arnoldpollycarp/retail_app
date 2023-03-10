defmodule ThamaniWeb.OrdersRetmanController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Retman_orders
  alias Thamani.Inventories
  alias Thamani.Retman_orders.Retman_order
  alias Thamani.Manufacturer_orders
  alias Thamani.Retail_Returns
  alias Thamani.Returns
  alias Thamani.Repo

  plug(:put_layout, "manufacturer.html")
  plug(:scrub_params, "retman_order" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user
    retman_order = Retman_orders.list_orders_retman(current_user.id)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    if retman_order do
      render(
        conn,
        "index.html",
        retman_order: retman_order,
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
      |> redirect(to: orders_retman_path(conn, :index))
    end
  end

  def new(conn, _params, _current_user) do
    conn
    |> put_flash(:error, "Not authorised to add to this page")
    |> redirect(to: orders_retman_path(conn, :index))
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)
    retman_order = Retman_orders.get_orders_retman(current_user.id, id)

    if retman_order do
      render(
        conn,
        "show.html",
        retman_order: retman_order,
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
      |> redirect(to: orders_retman_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    retman_order = Retman_orders.get_orders_retman(current_user.id, id)

    count_stock = Inventories.get_count_restock_man(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    if retman_order do
      changeset = Retman_order.changeset(retman_order, %{})

      render(
        conn,
        "edit.html",
        retman_order: retman_order,
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
      |> redirect(to: orders_retman_path(conn, :index))
    end
  end

  def update(
        conn,
        %{"id" => id, "retman_order" => retman_orders_params},
        current_user
      ) do
    retman_order = Retman_orders.get_orders_retman(current_user.id, id)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)
    changeset = Retman_order.changeset(retman_order, retman_orders_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "order updated successfully.")
        |> redirect(to: orders_retman_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          retman_order: retman_order,
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
