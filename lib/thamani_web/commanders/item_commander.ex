defmodule ThamaniWeb.ItemCommander do
  use Drab.Commander
  alias Thamani.Items

  access_session(:drab_test)

  defhandler replace_list(socket, sender) do
    poke(
      socket,
      long_process_button_text: "",
      price_text: "",
      quantity_text: "",
      weight_text: "",
      item_text: ""
    )
      poke(socket, loader_class: "loader-show")
    text = sender.params["gtin"]
    text2 = sender.params["mo"]
    items = Enum.join(Items.list_sku_name(text, text2))
    gtin = Items.list_sku_gtin(text, text2)
    description = Items.list_sku_description(text, text2)

    poke(socket, users: items, gtin: gtin, description: description)

    poke(socket, loader_class: "loader-hide")
  end

  defhandler add_items(socket, sender) do
    poke(socket, loader_class: "loader-hide")

    name = sender.params["name"]
    code = sender.params["code"]
    text = sender.params["text"]
    price = sender.params["price"]
    delivery = sender.params["delivery"]
    weight = sender.params["weight"]
    scode = sender.params["scode"]
    weight2 = sender.params["weight2"]
    width = sender.params["width"]
    length = sender.params["length"]
    height = sender.params["height"]
    quantity = sender.params["quantity"]
    quantity_unit = sender.params["quantity_unit"]
    min_quantity = sender.params["min_quantity"]
    category = sender.params["category"]
    image = sender.params["image"]
    active = sender.params["active"]

    if price == "" || min_quantity == "" || quantity_unit == "" || weight == "" || delivery == "" ||
         code == "" || code == "none" do
      poke(socket, loader_class: "loader-show")

      poke(socket, loader_class: "loader-hide")

      poke(socket, message_class: "alert alert-danger")

      poke(
        socket,
        alert_class: "alert alert-danger",
        long_process_button_text:
          "Check whether GTIN, Price ,Minimum Quantity or weight is filled in",
        price_text: "Cannot be empty",
        quantity_text: "Cannot be empty",
        quantity_unit_text: "Cannot be empty",
        weight_text: "Cannot be empty",
        item_text: "cannot be empty",
        code_text: "Cannot be empty.Search for it above"
      )
    else
      current_user = String.to_integer(sender.params["current_user"])
      check = Items.check_item_man(code, current_user)

      if check == 0 do
        Items.create_sku_node(
          name,
          code,
          text,
          price,
          delivery,
          weight,
          scode,
          weight2,
          width,
          length,
          height,
          quantity,
          String.to_integer(quantity_unit),
          String.to_integer(min_quantity),
          String.to_integer(category),
          image,
          active,
          current_user
        )

        poke(socket, loader_class: "loader-show")

        poke(socket, loader_class: "loader-hide")

        poke(
          socket,
          message_class: "alert alert-success",
          long_process_button_text:
            "Added Succesfully.... Either add another Item or close to go back ",
          price_text: "",
          quantity_text: "",
          weight_text: "",
          code_text: "",
          item_text: ""
        )
      else
        poke(socket, loader_class: "loader-show")

        poke(socket, loader_class: "loader-hide")

        poke(socket, message_class: "alert alert-danger")

        poke(
          socket,
          alert_class: "alert alert-danger",
          long_process_button_text: "The GTIN Entered already exists in your list",
          item_text: "Already Exist in your SKU Items"
        )
      end
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
