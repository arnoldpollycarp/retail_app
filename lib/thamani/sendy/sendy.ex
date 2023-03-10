defmodule Thamani.Sendy do
  @moduledoc """
  The Shops context.
  """

  import Ecto.Query, warn: false
  use HTTPotion.Base
  alias Thamani.Accounts
  alias Thamani.Sales

  def process_url() do
    get_api_url()
  end

  @doc """
  get the appropriate url from the configuration files.
  """
  def get_api_url do
    Application.get_env(:thamani, :api_url)
  end

  def get_api_username do
    Application.get_env(:thamani, :api_username)
  end

  def get_api_key do
    Application.get_env(:thamani, :api_key)
  end

  def get_timestamp do
    Timex.local()
    |> Timex.format!("{YYYY}-{0M}-{0D} {h24}:{m}:{s}")
  end

  def count_7(account) do
    date = String.slice(to_string(DateTime.utc_now()), 0..9)

    case Sales.get_count_manufacturer_value_today_api(account, date) do
      nil -> 0
      _ -> Float.ceil(Sales.get_count_manufacturer_value_today_api(account, date), 2)
    end
  end

  def count_8(account) do
    date = String.slice(to_string(DateTime.utc_now()), 0..9)

    case Sales.get_count_warehouse_value_today_api(account, date) do
      nil -> 0
      _ -> Float.ceil(Sales.get_count_warehouse_value_today_api(account, date), 2)
    end
  end

  def count_9(account) do
    date = String.slice(to_string(DateTime.utc_now()), 0..9)

    case Sales.get_count_retailer_value_today_api(account, date) do
      nil -> 0
      _ -> Float.ceil(Sales.get_count_retailer_value_today_api(account, date), 2)
    end
  end

  def requesttest(key, account) do
    HTTPotion.start()

    header = [
      connection: "keep-alive",
      "content-length": "452",
      "Content-Type": "application/json",
      Accept: "application/json",
      date: get_timestamp()
    ]

    body = %{
      "security_key" => key,
      "account_number" => account
    }

    account_number = Accounts.get_id(account)

    if is_nil(account_number) do
      %{body: "That account number you entered does not exist", status_code: 404}
    else
      user = Accounts.get_user(account_number)

      data = %{
        account_number: user.account_number,
        account_name: user.firstname <> " " <> user.lastname,
        date: String.slice(to_string(DateTime.utc_now()), 0..9),
        Total: count_7(user.id) + count_8(user.id) + count_9(user.id)
      }

      post("http://localhost:8000/api/sale_url/v1/post",
        body: Poison.encode!(body),
        headers: header
      )

      {:ok, %{body: data, status_code: 200, headers: process_response_headers(header)}}
    end
  end

  def senddata do
    HTTPotion.start()

    body = %{
      "security_key" => "WFv3dqP7oC+Od1GxnQFKwkdyf0i6ipSiTfKtARYSQShO0BwcuvPDLOizPRIiUH",
      "account_number" => "234565432345"
    }

    post("https://thamanionline.com/api/sale_url/v1/", body: Poison.encode!(body))
    |> process_response()
  end

  def processrequest(
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
      ) do
    timestamp = get_timestamp()

    body = %{
      "command" => "request",
      "data" => %{
        "api_key" => get_api_key(),
        "api_username" => get_api_username(),
        "vendor_type" => 1,
        "from" => %{
          "from_name" => from_name,
          "from_lat" => from_lat,
          "from_long" => from_long,
          "from_description" => ""
        },
        "to" => %{
          "to_name" => to_name,
          "to_lat" => to_lat,
          "to_long" => to_long,
          "to_description" => ""
        },
        "recepient" => %{
          "recepient_name" => recepient_name,
          "recepient_phone" => recepient_phone,
          "recepient_email" => recepient_email,
          "recepient_notes" => "recepient specific Notes"
        },
        "sender" => %{
          "sender_name" => sender_name,
          "sender_phone" => sender_phone,
          "sender_email" => sender_email,
          "sender_notes" => "Sender specific notes"
        },
        "delivery_details" => %{
          "pick_up_date" => timestamp,
          "collect_payment" => %{
            "status" => false,
            "pay_method" => 0,
            "amount" => 0
          },
          "return" => true,
          "note" => description,
          "note_status" => true,
          "request_type" => "delivery",
          # "order_type" => "ondemand_delivery",
          # "ecommerce_order" => "ecommerce_order_001",
          # "ecommerce_order" => false,
          "express" => false
          # "skew" => 1,
          #  "package_size" => [
          #    %{
          #      "weight" => 20,
          #      "height" => 10,
          #      "width" => 200,
          #      "length" => 30,
          #      "item_name" => "laptop"
          # }
          #  ]
        }
      },
      "request_token_id" => "request_token_id"
    }

    post(get_api_url(), body: Poison.encode!(body))
    |> process_response()
  end

  @doc """
  Process the response from the API
  """
  def process_response(%HTTPotion.Response{status_code: status_code, body: body} = resp) do
    cond do
      status_code == 200 ->
        {:ok, body, resp}

      true ->
        {:error, resp}
    end
  end
end
