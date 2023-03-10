defmodule ThamaniWeb.BarcodeController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Accounts

  alias Thamani.GTIN
  alias Thamani.Inventories
  alias Thamani.Retail_Returns
  alias Thamani.Manufacturer_orders
  alias Thamani.Retman_orders
  alias Thamani.Returns
  alias Thamani.GTIN.Barcode
  alias Thamani.Repo

  plug(:put_layout, "manufacturer.html")
  plug(:scrub_params, "barcode" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, params, current_user) do
    if current_user.userlevel do
      # barcode = GTIN.list_barcode()

      {query, rummage} =
        Barcode
        |> Barcode.rummage(params["rummage"])

      barcode =
        query
        |> Repo.all()

      count_stock = Inventories.get_count_restock_man(current_user)
      count_order = Manufacturer_orders.get_count_order(current_user)
      count_order_retman = Retman_orders.get_count_order_all()
      count_return = Returns.get_count_recieved(current_user)
      count_return_retail = Retail_Returns.get_count_recieved(current_user)

      render(
        conn,
        "index.html",
        barcode: barcode,
        rummage: rummage,
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return: count_return,
        count_return_retail: count_return_retail
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: manufacturer_dashboard_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    if current_user.userlevel do
      count_stock = Inventories.get_count_restock_man(current_user)
      count_order = Manufacturer_orders.get_count_order(current_user)
      count_order_retman = Retman_orders.get_count_order_all()
      count_return = Returns.get_count_recieved(current_user)
      count_return_retail = Retail_Returns.get_count_recieved(current_user)

      barcode = GTIN.get_barcode!(id)

      render(
        conn,
        "show.html",
        barcode: barcode,
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return: count_return,
        count_return_retail: count_return_retail
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: manufacturer_dashboard_path(conn, :index))
    end
  end

  def new(conn, params, current_user) do
    if current_user.userlevel do
      gtin = Accounts.get_barcode(current_user)
      count_stock = Inventories.get_count_restock_man(current_user)
      count_order = Manufacturer_orders.get_count_order(current_user)
      count_order_retman = Retman_orders.get_count_order_all()
      count_return = Returns.get_count_recieved(current_user)
      count_return_retail = Retail_Returns.get_count_recieved(current_user)

      changeset =
        current_user
        |> Ecto.build_assoc(:barcode)
        |> Barcode.changeset(params)

      render(
        conn,
        "new.html",
        changeset: changeset,
        gtin: gtin,
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return: count_return,
        count_return_retail: count_return_retail
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: manufacturer_dashboard_path(conn, :index))
    end
  end

  def create(conn, %{"barcode" => barcode_params}, current_user) do
    gtin = Accounts.get_barcode(current_user)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order_all()
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:barcode)
      |> Barcode.changeset(barcode_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "GTIN was created successfully")
        |> redirect(to: barcode_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          gtin: gtin,
          count_stock: count_stock,
          count_order: count_order,
          count_order_retman: count_order_retman,
          count_return: count_return,
          count_return_retail: count_return_retail
        )
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    if current_user.userlevel do
      barcode = GTIN.get_barcode!(id)

      gtin = Accounts.get_barcode(current_user)
      count_stock = Inventories.get_count_restock_man(current_user)
      count_order = Manufacturer_orders.get_count_order(current_user)
      count_order_retman = Retman_orders.get_count_order_all()
      count_return = Returns.get_count_recieved(current_user)
      count_return_retail = Retail_Returns.get_count_recieved(current_user)

      if barcode do
        changeset = Barcode.changeset(barcode, %{})

        render(
          conn,
          "edit.html",
          barcode: barcode,
          changeset: changeset,
          gtin: gtin,
          count_stock: count_stock,
          count_order: count_order,
          count_order_retman: count_order_retman,
          count_return: count_return,
          count_return_retail: count_return_retail
        )
      else
        conn
        |> put_flash(:error, "Not authorised to access that page")
        |> redirect(to: barcode_path(conn, :index, current_user.slug))
      end
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: manufacturer_dashboard_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "barcode" => code_params}, current_user) do
    barcode = GTIN.get_barcode!(id)

    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order_all()
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    changeset = Barcode.changeset(barcode, code_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "GTIN was updated successfully")
        |> redirect(to: barcode_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          barcode: barcode,
          changeset: changeset,
          count_stock: count_stock,
          count_order: count_order,
          count_order_retman: count_order_retman,
          count_return: count_return,
          count_return_retail: count_return_retail
        )
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    if current_user.userlevel do
      barcode = GTIN.get_barcode!(id)

      if current_user.id == barcode.user_id || current_user.userlevel do
        Repo.delete!(barcode)

        conn
        |> put_flash(:info, "GTIN was deleted successfully")
        |> redirect(to: barcode_path(conn, :index))
      else
        conn
        |> put_flash(:error, "You can’t delete this barcode")
        |> redirect(to: barcode_path(conn, :index))
      end
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: manufacturer_dashboard_path(conn, :index))
    end
  end
end
