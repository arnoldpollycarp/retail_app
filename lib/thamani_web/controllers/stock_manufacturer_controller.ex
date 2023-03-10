defmodule ThamaniWeb.StockManufacturerController do
  use ThamaniWeb, :controller
  alias Thamani.Inventories
  alias Thamani.Retail_Returns
  alias Thamani.Returns
  alias Thamani.Manufacturer_orders
  alias Thamani.Retman_orders
  alias Thamani.Items
  alias Thamani.Dispatches

    plug(:put_layout, "manufacturer.html")
    def action(conn, _) do
      apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
    end

    def index(conn, _params, current_user) do
    user = current_user
    bat = Items.get_items_datalist(current_user)
    company = Dispatches.get_company_datalist()
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    render(
    conn,
     "index.html",
     user: user,
     bat: bat,
     company: company,
     count_stock: count_stock,
     count_order: count_order,
     count_order_retman: count_order_retman,
     count_return: count_return,
     count_return_retail: count_return_retail,
     loader_class: " ",
     loader_class2: " ",
     message_class: " ",
     alert_class: " ",
     field_class: "display:none",
     select_class: " ",
     warehouse_text: " ",
     item_text: " ",
     delivered: 0,
     sent: 0,
     times_delivered: "",
     times_sent: "",
     long_process_button_text: " "
     )
  end
end
