defmodule ThamaniWeb.Gs1DashboardController do
  use ThamaniWeb, :controller
  alias Thamani.Dispatches
  require Ecto.Query
  require Ecto
  require Ecto.Schema

  plug(:put_layout, "dashboard.html")

  def index(conn, _params) do
    date = String.slice(to_string(DateTime.utc_now()), 0..9)
    company = Dispatches.get_company_datalist()

    render(
      conn,
      "dashboard.html",
      company: company,
      count_1: "loading",
      count_2: "loading",
      count_3: "loading",
      count_4: "loading",
      count_5: "loading",
      count_6: "loading",
      count_7: "loading",
      count_8: "loading",
      count_9: "loading",
      count_10: "loading",
      count_11: "loading",
      count_12: "0",
      count_13: "0",
      count_14: "0",
      count_15: "0",
      count_16: "0",
      count_17: "0",
      count_18: "0",
      count_19: "0",
      count_20: "0",
      count_21: "0",
      date_search: date,
      date_search_2: date,
      loader_class: ""
    )
  end
end
