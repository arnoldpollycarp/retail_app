defmodule ThamaniWeb.RetailDashboardController do
  use ThamaniWeb, :controller

  require Ecto.Query
  require Ecto
  require Ecto.Schema
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches_Retailer
  alias Thamani.Inventories

  alias Thamani.Repo

  plug(:put_layout, "retail.html")

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    inventory =
      user
      |> user_inventory
      |> Repo.all()
      |> Repo.preload(:sku)

    date = String.slice(to_string(DateTime.utc_now()), 0..9)
    date_1 = String.slice(to_string(Timex.shift(DateTime.utc_now(), days: 60)), 0..9)
    list_expiry = Inventories.list_inventory_by_expiry(date_1, date, current_user)
    count_1 = Inventories.get_count_inventory(current_user)
    count_4 = Inventories.get_count_restock(current_user)

    sum_1 =
      case Inventories.get_sum_inventory_price(current_user) do
        nil -> 0.0
        _ -> Inventories.get_sum_inventory_price(current_user)
      end

    sum_s =
      case Inventories.get_sum_quantity_sales(current_user) do
        nil -> 0.0
        _ -> Inventories.get_sum_quantity_sales(current_user)
      end

    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)
    count = Dispatches_Warehouse.get_count_recieved(current_user.id)
    count_7 = Dispatches_Retailer.get_count_recieved(current_user.id)

    render(
      conn,
      "dashboard.html",
      user: user,
      list_expiry: list_expiry,
      sum_1: sum_1,
      sum_s: sum_s,
      count: count,
      count_1: count_1,
      count_2: "Loading",
      count_3: "Loading",
      count_4: count_4,
      count_5: count_5,
      count_6: count_6,
      count_7: count_7,
      inventory: inventory
    )
  end

  defp user_inventory(user) do
    Ecto.assoc(user, :inventories)
  end
end
