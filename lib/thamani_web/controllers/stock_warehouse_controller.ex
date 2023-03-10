defmodule ThamaniWeb.StockWarehouseController do
  use ThamaniWeb, :controller
  alias Thamani.Inventories
  alias Thamani.Items
  alias Thamani.Dispatches
  alias Thamani.Inventories
  alias Thamani.Warehouse_orders
    plug(:put_layout, "warehouse.html")
    def action(conn, _) do
      apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
    end

    def index(conn, _params, current_user) do
    user = current_user
    bat = Dispatches.get_recieved_select_datalist(current_user.id)
    company = Dispatches.get_company_datalist()
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    render(
    conn,
     "index.html",
     user: user,
     bat: bat,
     company: company,
     count_7: count_7,
     count_order: count_order,
     count_stock: count_stock,
     loader_class: " ",
     loader_class2: " ",
     message_class: " ",
     alert_class: " ",
     field_class: "display:none",
     select_class: " ",
     retailer_text: " ",
     item_text: " ",
     available: 0,
     received: 0,
     sold: 0,
     long_process_button_text: " "
     )
  end
end
