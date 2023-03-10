defmodule ThamaniWeb.RreturnAdminController do
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

  def index(conn, _params) do
    recieved = Retail_Returns.list_retail_returns()
    count_order = Manufacturer_orders.get_count_order_all()
    count_order_retman = Retman_orders.get_count_order_all()
    count_stock = Inventories.get_count_restock_man_all()
    count_return = Returns.get_count_recieved_all()
    count_return_retail = Retail_Returns.get_count_recieved_all()

    render(
      conn,
      "index.html",
      recieved: recieved,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return_retail: count_return_retail,
      count_return: count_return
    )
  end

  def show(conn, %{"id" => id}) do
    count_order = Manufacturer_orders.get_count_order_all()
    count_order_retman = Retman_orders.get_count_order_all()
    count_stock = Inventories.get_count_restock_man_all()
    count_return = Returns.get_count_recieved_all()
    count_return_retail = Retail_Returns.get_count_recieved_all()
    recieved = Retail_Returns.get_retail_return!(id)

    render(
      conn,
      "show.html",
      recieved: recieved,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return_retail: count_return_retail,
      count_return: count_return
    )
  end

  def edit(conn, %{"return_id" => companies, "id" => id}, current_user) do
    recieved = Retail_Returns.get_recieved(companies, id)
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
        %{"return_id" => companies, "id" => id, "retail__return" => recieved_params},
        current_user
      ) do
    recieved = Retail_Returns.get_recieved(companies, id)
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
