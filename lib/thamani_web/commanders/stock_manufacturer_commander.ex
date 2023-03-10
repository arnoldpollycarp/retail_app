defmodule ThamaniWeb.StockManufacturerCommander do
  use Drab.Commander

  alias Thamani.Sales
  alias Thamani.Invoicing
  alias Thamani.Dispatches
    alias Thamani.Dispatches_Warehouse

  access_session(:drab_test)

  defhandler fetch_stock(socket, sender) do
    poke(socket, message_class: "alert alert-warning",long_process_button_text: "Fetching Data from warehouse")
    current_user = String.to_integer(sender.params["current_user"])
    item = to_string(sender.params["item"])
    warehouse = to_string(sender.params["warehouse"])
    quantity_delivered =
      case Dispatches.get_quantity_delivered(item, warehouse) do
        nil -> 0
        _ -> Decimal.to_integer(Dispatches.get_quantity_delivered(item, warehouse))
      end

    times_delivered =
      case Dispatches.get_times_delivered(item, warehouse) do
        nil -> 0
        _ -> Dispatches.get_times_delivered(item, warehouse)
      end

    quantity_sent =
      case Dispatches.get_quantity_sent(item, warehouse) do
        nil -> 0
        _ -> Decimal.to_integer(Dispatches.get_quantity_sent(item, warehouse))
      end

    times_sent =
      case Dispatches.get_times_sent(item, warehouse) do
        nil -> 0
        _ -> Dispatches.get_times_sent(item, warehouse)
      end



    if item == "" || warehouse == ""  do
      poke(socket, loader_class: "loader-show")

    poke(socket, message_class: "alert alert-danger")

      poke(
        socket,
        alert_class: "alert alert-warning",
        long_process_button_text:
          "Check whether Item, Warehouse is empty in",
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
        field_class: "display:inline-block",
        warehouse_text: "",
        item_text: "",
        delivered: quantity_delivered,
        sent: quantity_sent,
        times_delivered: times_delivered,
        times_sent: times_sent
      )
        poke(socket, loader_class: "loader-hide")
    end
  end

end
