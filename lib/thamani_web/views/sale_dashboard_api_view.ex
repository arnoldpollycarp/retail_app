defmodule ThamaniWeb.SaleDashboardApiView do
  use ThamaniWeb, :view
  alias Thamani.Sales

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

  def render("index.json", %{users: users}) do
    %{data: render_many(users, ThamaniWeb.SaleDashboardApiView, "saledashboard.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, ThamaniWeb.SaleDashboardApiView, "saledashboard.json")}
  end

  def render("saledashboard.json", %{sale_dashboard_api: sale_dashboard_api}) do
    %{
      account_number: sale_dashboard_api.account_number,
      account_name: sale_dashboard_api.firstname <> " " <> sale_dashboard_api.lastname,
      company: sale_dashboard_api.company,
      date: String.slice(to_string(DateTime.utc_now()), 0..9),
      Total:
        count_7(sale_dashboard_api.id) + count_8(sale_dashboard_api.id) +
          count_9(sale_dashboard_api.id)
    }
  end
end
