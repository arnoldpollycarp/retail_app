defmodule ThamaniWeb.ItemAdminController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Accounts
  alias Thamani.Items.Sku
  alias Thamani.Items
  alias Thamani.Retail_Returns
  alias Thamani.Returns
  alias Thamani.Inventories
  alias Thamani.Manufacturer_orders
  alias Thamani.Retman_orders
  alias Thamani.Pmasters
  alias Thamani.Repo

  plug(:put_layout, "manufacturer.html")
  plug(:scrub_params, "sku" when action in [:create, :update])

  def index(conn, _params) do
    count_stock = Inventories.get_count_restock_man_all()
    count_order = Manufacturer_orders.get_count_order_all()
    count_order_retman = Retman_orders.get_count_order_all()
    count_return = Returns.get_count_recieved_all()
    count_return_retail = Retail_Returns.get_count_recieved_all()
    items = Items.list_sku()
    item = Items.list_sku_items()

    render(
      conn,
      "index.html",
      items: items,
      item: item,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return: count_return,
      count_return_retail: count_return_retail,
      loader_class: " ",
      message_class: " ",
      alert_class: " ",
      long_process_button_text: " ",
      price_text: " ",
      quantity_text: " ",
      weight_text: " ",
      users: "none",
      access_log: "",
      gtin: "none",
      description: "none",
      title: "List",
      text: "",
      text2: ""
    )
  end

  def show(conn, %{"id" => id}) do
    items = Items.list_sku_user(id)

    count_stock = Inventories.get_count_restock_man_all()
    count_order = Manufacturer_orders.get_count_order_all()
    count_order_retman = Retman_orders.get_count_order_all()
    count_return = Returns.get_count_recieved_all()
    count_return_retail = Retail_Returns.get_count_recieved_all()

    render(
      conn,
      "show.html",
      items: items,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return: count_return,
      count_return_retail: count_return_retail
    )
  end


    def edit(conn, %{"id" => id}) do
        item = Items.get_sku!(id)
      cat = Pmasters.get_items_id()

          count_stock = Inventories.get_count_restock_man_all()
          count_order = Manufacturer_orders.get_count_order_all()
          count_order_retman = Retman_orders.get_count_order_all()
          count_return = Returns.get_count_recieved_all()
          count_return_retail = Retail_Returns.get_count_recieved_all()

      auser = Accounts.get_users()


      if item do
        changeset = Sku.changeset(item, %{})

        render(
          conn,
          "edit.html",
          item: item,
          changeset: changeset,

          cat: cat,
          auser: auser,
          count_stock: count_stock,
          count_order: count_order,
          count_order_retman: count_order_retman,
          count_return: count_return,
          count_return_retail: count_return_retail
        )
      else
        conn
        |> put_flash(:error, "Not authorised to access this page")
        |> redirect(to: item_path(conn, :index))
      end
    end

    def update(conn, %{"id" => id, "sku" => item_params}) do
        item = Items.get_sku!(id)
      cat = Pmasters.get_items_id()

          count_stock = Inventories.get_count_restock_man_all()
          count_order = Manufacturer_orders.get_count_order_all()
          count_order_retman = Retman_orders.get_count_order_all()
          count_return = Returns.get_count_recieved_all()
          count_return_retail = Retail_Returns.get_count_recieved_all()

      changeset = Sku.changeset(item, item_params)

      case Repo.update(changeset) do
        {:ok, _} ->
          conn
          |> put_flash(:info, "Item was updated successfully")
          |> redirect(to: item_admin_path(conn, :index))

        {:error, changeset} ->
          render(
            conn,
            "edit.html",
            item: item,
            cat: cat,
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
