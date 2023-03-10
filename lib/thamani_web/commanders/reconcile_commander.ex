defmodule ThamaniWeb.ReconcileCommander do
  use Drab.Commander

  alias Thamani.Sales
  alias Thamani.Invoicing
  alias Thamani.Dispatches
  alias Thamani.Accounts

  access_session(:drab_test)
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
  defhandler fetch_list(socket, sender) do
  
    mid = String.to_integer(sender.params["current_user"])

    date = to_string(sender.params["date"])
    date_1 = to_string(sender.params["date_1"])
    list_users = Accounts.list_users()

    sum_sales = Sales.sum_sales_price_manufacturer_invoice(mid, date, date_1)

    poke(socket, loader_class: "loader-show")

    poke(socket,
      list_users: list_users,

      date_0: date,
      date_01: date_1,

    )

    poke(socket, loader_class: "loader-hide")
  end

end
