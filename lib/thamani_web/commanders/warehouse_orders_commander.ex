defmodule ThamaniWeb.WarehouseOrdersCommander do
  use Drab.Commander
  alias Thamani.Items
  alias Thamani.Warehouse_orders
  alias Thamani.Manufacturer_orders
  alias Thamani.Kcitys

  defhandler return_company(socket, sender) do
    poke(socket, loader_class: "loader-show")

    cat = sender.params["category"]
    list_company = Warehouse_orders.list_companies(cat)

    poke(socket, loader_class: "loader-hide")

    poke(socket, list_company: list_company)
  end

  defhandler return_item(socket, sender) do
    poke(socket, loader_class2: "loader-show")

    cat = sender.params["category"]

    warehouse = sender.params["warehouse_id"]

    list_item = Warehouse_orders.list_sku_name(cat, warehouse)

    poke(socket, loader_class2: "loader-hide")

    poke(socket, list_item: list_item)
  end

  defhandler return_uom(socket, sender) do
    poke(socket, loader_class3: "loader-show")

    item = sender.params["item"]

    warehouse = sender.params["warehouse_id"]

    list_city = Kcitys.list_kcity()

    company = Warehouse_orders.get_warehouse_name(warehouse)

    phone = Warehouse_orders.get_warehouse_phone(warehouse)

    id = warehouse

    item_id = item

    image = Items.get_image(item)

    delivery = Warehouse_orders.get_delivery(item)

    description = Warehouse_orders.get_description(item)

    price = Manufacturer_orders.get_price(item)

    poke(socket, loader_class3: "loader-hide")

    poke(socket, field_class2: "display:inline-block")

    poke(
      socket,
      list_city: list_city,
      company: company,
      id: id,
      phone: phone,
      price: price,
      item_id: item_id,
      image: image,
      delivery: delivery,
      description: description
    )
  end

  defhandler add_order(socket, sender) do
    poke(socket, loader_class4: "loader-hide")
    cid = sender.params["order_id"]
    category = String.to_integer(sender.params["category"])
    item = sender.params["item"]
    delivery = sender.params["delivery"]
    city = sender.params["city"]
    item_id = sender.params["item_id"]
    warehouse = sender.params["warehouse"]
    quantity = sender.params["quantity"]
    description = sender.params["description"]

    if item == "" || category == "" || quantity == "" do
      poke(socket, loader_class4: "loader-show")

      poke(socket, loader_class4: "loader-hide")

      poke(socket, message_class: "alert alert-danger")

      poke(
        socket,
        alert_class: "alert alert-danger",
        long_process_button_text:
          "Check whether Category ,delivery or Brand of item is filled in",
        item_text: "Cannot be empty",
        quantity_text: "Cannot be empty"
      )
    else
      current_user = String.to_integer(sender.params["current_user"])
      poke(socket, loader_class4: "loader-show")

      Warehouse_orders.create_orders(
        cid,
        category,
        String.to_integer(item_id),
        delivery,
        String.to_integer(city),
        String.to_integer(warehouse),
        String.to_integer(quantity),
        description,
        current_user
      )

      poke(socket, loader_class4: "loader-hide")

      poke(
        socket,
        message_class: "alert alert-success",
        long_process_button_text:
          "Added Succesfully.... Either add another order or close to go back ",
        item_text: "",
        quantity_text: ""
      )

      poke(socket, field_class2: "display:none")
    end
  end
end
