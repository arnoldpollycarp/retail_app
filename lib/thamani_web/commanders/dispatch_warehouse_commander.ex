defmodule ThamaniWeb.DispatchWarehouseCommander do
  use Drab.Commander
  alias Thamani.Dispatches
  alias Thamani.Sendy

  access_session(:drab_test)

  defhandler fetch_data(socket, sender) do
    from_name = sender.params["from_name"]
    from_lat = sender.params["lat"]
    from_long = sender.params["lng"]
    to_name = sender.params["to_name"]
    to_lat = sender.params["latitude"]
    to_long = sender.params["longitude"]
    recepient_name = sender.params["recepient_name"]
    recepient_phone = sender.params["recepient_phone"]
    recepient_email = sender.params["recepient_email"]
    retailer = sender.params["retailer_id"]
    sender_name = Dispatches.get_warehouse_name(retailer)
    sender_phone = Dispatches.get_warehouse_phone(retailer)
    sender_email = Dispatches.get_warehouse_email(retailer)
    description = sender.params["description"]
    quantity = sender.params["quantity"]
    item = sender.params["item_id"]

    poke(socket, loader_class: "loader-show")

    changeset =
      Sendy.processrequest(
        from_name,
        from_lat,
        from_long,
        to_name,
        to_lat,
        to_long,
        recepient_name,
        recepient_phone,
        recepient_email,
        sender_name,
        sender_phone,
        sender_email,
        description
      )

    {:error, %HTTPotion.Response{status_code: status_code, body: body, headers: headers}} =
      changeset

    IO.inspect(headers)

    IO.inspect(
      Poison.Parser.parse!(
        body
        |> String.replace("\n", "")
        |> String.replace("\"data", ",\"data")
      )
    )

    # IO.inspect Poison.Parser.parse!(body |> String.replace("\n", ""))
    if status_code == 201 do
      %{
        "data" => %{
          "amount" => amount,
          # "amount_return" => amount_return,
          # "drop_shipping_order" => drop_order,
          #  "order_status" => order_status,
          # "pick_up_date" => date,
          "currency" => currency,
          "distance" => distance,
          "eta" => eta,
          "etd" => etd,
          "order_no" => order
        },
        "request_token_id" => "request_token_id",
        "status" => _status
      } =
        Poison.Parser.parse!(
          body
          |> String.replace("\n", "")
          |> String.replace("\"data", ",\"data")
        )

      poke(
        socket,
        item: item,
        retailer: retailer,
        from_name: from_name,
        to_name: to_name,
        quantity: quantity,
        description: description,
        order: order,
        amount: amount,
        eta: eta,
        etd: etd,
        currency: currency,
        distance: distance
      )
    end

    poke(socket, loader_class: "loader-hide")

    poke(
      socket,
      message_class: "alert alert-success",
      long_process_button_text: "Order initiated"
    )
  end
end
