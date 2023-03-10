defmodule ThamaniWeb.ManufacturerOrdersCommander do
  use Drab.Commander
  alias Thamani.Items
  alias Thamani.Manufacturer_orders
  alias Thamani.Kcitys

  defhandler return_company(socket, sender) do
    poke(socket, loader_class: "loader-show")

    cat = sender.params["category"]

    list_company = Manufacturer_orders.list_companies(cat)

    poke(socket, loader_class: "loader-hide")

    poke(socket, list_company: list_company)
  end

  defhandler return_item(socket, sender) do
    poke(socket, loader_class2: "loader-show")

    cat = sender.params["category"]

    manufacturer = sender.params["manufacturer_id"]

    list_item = Manufacturer_orders.list_sku_name(cat, manufacturer)

    poke(socket, loader_class2: "loader-hide")

    poke(socket, list_item: list_item)
  end

  defhandler return_uom(socket, sender) do
    poke(socket, loader_class3: "loader-show")

    item = sender.params["item"]

    manufacturer = sender.params["manufacturer_id"]

    list_city = Kcitys.list_kcity()

    company = Manufacturer_orders.get_manufacturer_name(manufacturer)

    phone = Manufacturer_orders.get_manufacturer_phone(manufacturer)

    image = Items.get_image(item)

    id = manufacturer

    delivery = Manufacturer_orders.get_delivery(item)

    description = Manufacturer_orders.get_description(item)

    price = Manufacturer_orders.get_price(item)

    min_quantity = Manufacturer_orders.get_min_quantity(item)

    unit = Manufacturer_orders.get_quantity_unit(item)

    poke(socket, loader_class3: "loader-hide")

    poke(socket, field_class2: "display:inline-block")

    poke(
      socket,
      list_city: list_city,
      company: company,
      image: image,
      id: id,
      min_quantity: min_quantity,
      unit: unit,
      delivery: delivery,
      phone: phone,
      price: price,
      description: description
    )
  end

  defhandler add_order(socket, sender) do
    poke(socket, loader_class4: "loader-show")
    cid = sender.params["order_id"]
    category = sender.params["category"]
    item = sender.params["item"]
    delivery = sender.params["delivery"]
    city = sender.params["city"]
    manufacturer = sender.params["manufacturer"]
    quantity = sender.params["quantity"]
    min = sender.params["min"]
    description = sender.params["description"]

    if String.to_integer(quantity) < 1 do
      poke(socket, loader_class4: "loader-show")

      poke(socket, loader_class4: "loader-hide")

      poke(socket, message_class: "alert alert-danger")

      poke(
        socket,
        alert_class: "alert alert-danger",
        long_process_button_text: "Cannot be below the minimum quantity of manufacturer",
        quantity_text: "Cannot be below the minimum quantity of manufacturer"
      )
    else
      if item == "" || category == "" || delivery == "" || quantity == "" do
        poke(socket, loader_class3: "loader-show")

        poke(socket, loader_class3: "loader-hide")

        poke(socket, message_class: "alert alert-danger")

        poke(
          socket,
          alert_class: "alert alert-danger",
          long_process_button_text:
            "Check whether Category ,delivery or Brand,or quantity of item is filled in",
          item_text: "Cannot be empty",
          uom_text: "Cannot be empty"
        )
      else
        current_user = String.to_integer(sender.params["current_user"])
        poke(socket, loader_class3: "loader-show")

        Manufacturer_orders.create_orders(
          cid,
          String.to_integer(category),
          String.to_integer(item),
          delivery,
          String.to_integer(city),
          String.to_integer(manufacturer),
          String.to_integer(quantity),
          description,
          current_user
        )

        poke(socket, loader_class3: "loader-hide")

        poke(
          socket,
          message_class: "alert alert-success",
          long_process_button_text:
            "Added Succesfully.... Either add another order or close to go back ",
          item_text: "",
          uom_text: "",
          quantity_text: ""
        )

        poke(socket, field_class2: "display:none")
      end
    end
  end
end
