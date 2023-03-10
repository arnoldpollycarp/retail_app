defmodule ThamaniWeb.StockRetmanCommander do
  use Drab.Commander

  alias Thamani.Sales
  alias Thamani.Inventories


  access_session(:drab_test)

  defhandler fetch_stock(socket, sender) do
    poke(socket, message_class: "alert alert-warning",long_process_button_text: "Fetching Data from warehouse")
    current_user = String.to_integer(sender.params["current_user"])
    item = to_string(sender.params["item"])
    retailer = to_string(sender.params["retailer"])

    quantity_available =
      case Inventories.get_item_count_quantity_stock(item, retailer) do
        nil -> 0
        _ -> Decimal.to_integer(Inventories.get_item_count_quantity_stock(item, retailer))
      end

    quantity_ware =
        case Inventories.get_item_count_quantity_stock_ware(item, retailer) do
          nil -> 0
          _ -> Decimal.to_integer(Inventories.get_item_count_quantity_stock_ware(item, retailer))
        end
    quantity_ret =
          case Inventories.get_item_count_quantity_stock_ret(item, retailer) do
            nil -> 0
            _ -> Decimal.to_integer(Inventories.get_item_count_quantity_stock_ret(item, retailer))
          end

    quantity_sold =
      case Sales.get_count_quantity_item_stock(retailer,item) do
        nil -> 0
        _ -> Decimal.to_integer(Sales.get_count_quantity_item_stock(retailer,item))
      end



    if item == "" || retailer == ""  do
      poke(socket, loader_class: "loader-show")

    poke(socket, message_class: "alert alert-danger")

      poke(
        socket,
        alert_class: "alert alert-warning",
        long_process_button_text:
          "Check whether Item, Retailer is empty in",
        item_text: "Cannot be empty",
        warehouse_text: "Cannot be empty",

      )
    poke(socket, loader_class: "loader-hide")
    else

      poke(socket, loader_class: "loader-show")

      poke(
        socket,
        message_class: "alert alert-success",
        long_process_button_text:
          "Details Fetched successfully ",
        field_class: "display:inline-block;background: #f5f5f5;border: 2px solid #e5e5e5;",
        retailer_text: "",
        item_text: "",
        available: quantity_available,
        received: (quantity_ware + quantity_ret),

        sold: quantity_sold

      )
        poke(socket, loader_class: "loader-hide")
    end
  end

end
