defmodule ThamaniWeb.SaleDashboardController do
  use ThamaniWeb, :controller
  alias Thamani.Dispatches
  require Ecto.Query
  require Ecto
  require Ecto.Schema

  plug(:put_layout, "extra.html")

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    date = String.slice(to_string(DateTime.utc_now()), 0..9)
    company = Dispatches.get_company_datalist()
    user = current_user

    render(
      conn,
      "dashboard.html",
      company: company,
      user: user,
      count_0: 0.0,
      count_1: 0.0,
      count_2: 0.0,
      count_3: "loading",
      count_4: 0.0,
      count_5: "loading",
      count_6: 0.0,
      count_7: 0.0,
      count_8: 0.0,
      count_9: 0.0,
      count_10: 0.0,
      count_11: 0.0,
      count_12: 0.0,
      count_13: 0.0,
      count_14: 0.0,
      count_15: 0.0,
      date_search: date,
      date_search_2: date,
      loader_class: ""
    )
  end
end
