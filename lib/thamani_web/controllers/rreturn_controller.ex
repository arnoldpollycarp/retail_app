defmodule ThamaniWeb.RreturnController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Retail_Returns.Retail_Return
  alias Thamani.Retail_Returns
  alias Thamani.Returns
  alias Thamani.Inventories
  alias Thamani.Dispatches
  alias Thamani.Manufacturer_orders
  alias Thamani.Retman_orders
  alias Thamani.Repo

  plug(:put_layout, "manufacturer.html")
  plug(:scrub_params, "retail__return" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user
    recieved = Retail_Returns.list_recieved(current_user.id)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)
    count_return = Returns.get_count_recieved(current_user)

    if recieved do
      render(
        conn,
        "index.html",
        recieved: recieved,
        user: user,
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return_retail: count_return_retail,
        count_return: count_return
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: rreturn_path(conn, :index))
    end
  end

  def new(conn, _params, _current_user) do
    conn
    |> put_flash(:error, "Not authorised to add to this page")
    |> redirect(to: rreturn_path(conn, :index))
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)
    count_return = Returns.get_count_recieved(current_user)
    recieved = Retail_Returns.get_recieved(current_user.id, id)

    if recieved do
      render(
        conn,
        "show.html",
        recieved: recieved,
        user: user,
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return_retail: count_return_retail,
        count_return: count_return
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: rreturn_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    recieved = Retail_Returns.get_recieved(current_user.id, id)
    bat = Inventories.get_items(current_user)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)
    count_return = Returns.get_count_recieved(current_user)
    company = Dispatches.get_company()

    if recieved do
      changeset = Retail_Return.changeset(recieved, %{})

      render(
        conn,
        "edit.html",
        recieved: recieved,
        changeset: changeset,
        bat: bat,
        company: company,
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return_retail: count_return_retail,
        count_return: count_return
      )
    else
      conn
      |> put_flash(:error, "Not authorised to edit this page")
      |> redirect(to: rreturn_path(conn, :index))
    end
  end

  def update(
        conn,
        %{"id" => id, "retail__return" => recieved_params},
        current_user
      ) do
    recieved = Retail_Returns.get_recieved(current_user.id, id)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)
    count_return = Returns.get_count_recieved(current_user)
    changeset = Retail_Return.changeset(recieved, recieved_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "recieved updated successfully.")
        |> redirect(to: rreturn_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          recieved: recieved,
          changeset: changeset,
          count_stock: count_stock,
          count_order: count_order,
          count_order_retman: count_order_retman,
          count_return_retail: count_return_retail,
          count_return: count_return
        )
    end
  end
end
