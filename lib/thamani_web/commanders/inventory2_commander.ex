defmodule ThamaniWeb.Inventory2Commander do
  use Drab.Commander
  alias Thamani.Inventories
  alias Thamani.Dispatches
  alias Thamani.Dispatches_Retailer
  alias Thamani.Pmasters
  alias Thamani.Sales

  access_session(:drab_test)

  defhandler range_retailer(socket, sender) do
    text = sender.params["item"]

    current_user = Drab.Live.peek(socket, :current_user)

    items_details = Dispatches_Retailer.get_recieved_retail(current_user, text)

    poke(socket, loader_class2: "loader-show")

    poke(socket, loader_class2: "loader-hide")

    poke(socket, field_class: "display:inline-block")

    poke(socket, items_details: items_details)
  end

  defhandler add_items(socket, sender) do
    poke(socket, loader_class: "loader-hide")

    text = sender.params["item_id"]
    item = String.to_integer(sender.params["name"])
    price = sender.params["price"]
    quantity = sender.params["quantity"]
    description = sender.params["description"]

    max =
      Pmasters.get_max(Dispatches.getcategoryname(item)) / 100 *
        String.to_float(Dispatches.get_price(item))

    active = sender.params["active"]
    current_user = String.to_integer(sender.params["current_user"])
    batch = sender.params["batch"]
    expiry = sender.params["expiry"]
    production = sender.params["production"]
    reorderlevel = String.to_integer(sender.params["reorderlevel"])
    reorderstock = String.to_integer(sender.params["quantity"])
    check = Inventories.check_recieved_code(current_user, text)

    if check == 0 do
      if item == "" || price == "" do
        poke(socket, loader_class: "loader-show")

        poke(socket, loader_class: "loader-hide")

        poke(
          socket,
          message_class: "alert alert-danger",
          long_process_button_text: "Check whether Price or Item is filled",
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
          price_1 = Dispatches.get_price(item)
          mid = Sales.get_item_manufacturer(item)
          wid = 0

          Inventories.create_inventory_node_manufacturer(
            item,
            price,
            mid,
            String.to_float(price_1),
            0.0,
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
            String.to_integer(text),
            "Manufacturer",
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
end
