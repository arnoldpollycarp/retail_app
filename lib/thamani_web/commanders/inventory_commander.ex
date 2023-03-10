defmodule ThamaniWeb.InventoryCommander do
  use Drab.Commander
  alias Thamani.Items
  alias Thamani.Breakbulks
  alias Thamani.Inventories
  alias Thamani.Dispatches
  alias Thamani.Pmasters
  alias Thamani.Sales
  alias Thamani.Reorders
  alias Thamani.Dispatches_Warehouse

  access_session(:drab_test)

  defhandler replace_list(socket, sender) do
    text = sender.params["recieved"]

    items = Breakbulks.list_breakbulk_code(text)

    poke(socket, loader_class: "loader-show")

    poke(socket, loader_class: "loader-hide")

    poke(socket, items: items)
  end

  defhandler range(socket, sender) do
    text = sender.params["item"]

    items_details = Breakbulks.list_breakbulk_id(text)

    poke(socket, loader_class2: "loader-show")

    poke(socket, loader_class2: "loader-hide")

    poke(socket, field_class: "display:inline-block")

    poke(socket, items_details: items_details)
  end

  defhandler add_reorder(socket, sender) do
    poke(socket, loader_class: "loader-hide")

    item = sender.params["inventory_item"]
    type = sender.params["typeId"]
    mid = String.to_integer(sender.params["mId"])
    wid = String.to_integer(sender.params["wId"])
    quantity = sender.params["quantity"]
    description = sender.params["description"]
    current_user = Drab.Live.peek(socket, :current_user)
    date = String.slice(to_string(DateTime.utc_now()), 0..9)
    check_quantity = Items.check_min_quantity(item)
    check_reorder_today = Reorders.check_reorder_today_item(item, date)

    if check_quantity > String.to_integer(quantity) do
      poke(socket, loader_class: "loader-show")

      poke(socket, loader_class: "loader-hide")

      poke(
        socket,
        message_class: "alert alert-danger",
        long_process_button_text:
          "The quantity cannot be below the minimum quantity | #{check_quantity}"
      )
    else
      if check_reorder_today > 0 do
        poke(socket, loader_class: "loader-show")

        poke(socket, loader_class: "loader-hide")

        poke(
          socket,
          message_class: "alert alert-danger",
          long_process_button_text: "The reorder for this item has already been made"
        )
      else
        Reorders.create_reorder_node(
          String.to_integer(item),
          type,
          mid,
          wid,
          String.to_integer(quantity),
          date,
          description,
          current_user.id
        )

        poke(socket, long_process_button_text: "")

        poke(socket, loader_class: "loader-show")

        poke(socket, loader_class: "loader-hide")

        poke(
          socket,
          message_class: "alert alert-success",
          long_process_button_text: "Reorder has been added succesfully "
        )
      end
    end
  end

  defhandler add_items(socket, sender) do
    poke(socket, loader_class: "loader-hide")
    breakbulk_code = String.to_integer(sender.params["code"])
    shipping = sender.params["shipping"]
    item = sender.params["name"]

    price = sender.params["price"]
    quantity = sender.params["quantity"]
    description = sender.params["description"]
    active = sender.params["active"]
    reorderlevel = String.to_integer(sender.params["reorderlevel"])
    reorderstock = String.to_integer(sender.params["quantity"])
    batch = sender.params["batch"]
    expiry = sender.params["expiry"]
    production = sender.params["production"]

    max =
      Pmasters.get_max(Dispatches.getcategoryname(item)) / 100 *
        String.to_float(Dispatches.get_price(item))

    current_user = String.to_integer(sender.params["current_user"])

    check = Inventories.check_code(breakbulk_code, current_user)

    if check == 0 do
      if price == "" do
        poke(socket, loader_class: "loader-show")

        poke(socket, loader_class: "loader-hide")

        poke(socket, message_class: "alert alert-danger")

        poke(
          socket,
          alert_class: "alert alert-danger",
          long_process_button_text: "Check whether Price or Item is filled in",
          price_text: "Cannot be empty"
        )
      else
        if String.to_float(price) > max do
          poke(socket, loader_class: "loader-show")

          poke(socket, loader_class: "loader-hide")

          poke(
            socket,
            message_class: "alert alert-danger",
            long_process_button_text: "The price range exceeded",
            price_text: "Check price"
          )
        else
          current_user = String.to_integer(sender.params["current_user"])

          price_1 = String.to_float(Dispatches.get_price(item))
          mid = Sales.get_item_manufacturer(item)
          wid = Sales.get_item_warehouse!(shipping, current_user)

          Inventories.create_inventory_node(
            String.to_integer(item),
            price,
            mid,
            price_1,
            Dispatches_Warehouse.get_warehouse_value(),
            wid,
            Sales.get_gs1_value(),
            description,
            String.to_integer(quantity),
            active,
            reorderstock,
            reorderlevel,
            batch,
            expiry,
            production,
            breakbulk_code,
            "Warehouse",
            current_user
          )

          poke(socket, loader_class: "loader-show")

          poke(socket, loader_class: "loader-hide")

          poke(
            socket,
            message_class: "alert alert-success",
            long_process_button_text:
              "Added Succesfully.... Either add another Inventory or close to go back ",
            price_text: ""
          )

          poke(socket, field_class: "display:none")
        end
      end
    else
      poke(
        socket,
        message_class: "alert alert-danger",
        price_text: "",
        long_process_button_text: "The Item you are adding already exists in your inventory."
      )

      poke(socket, field_class: "display:none")
    end
  end

  defhandler replace_title(socket, _sender) do
    Drab.Live.poke(socket, title: "New, better Title")
  end

  defhandler uppercase(socket, sender) do
    text = sender.params["text_to_uppercase"]
    Drab.Live.poke(socket, text: String.upcase(text))
  end

  defhandler downcase(socket, sender) do
    text = sender.params["text_to_uppercase"]
    Drab.Live.poke(socket, text: String.downcase(text))
  end
end
