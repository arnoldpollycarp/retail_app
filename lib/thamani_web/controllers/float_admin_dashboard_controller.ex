defmodule ThamaniWeb.FloatAdminDashboardController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Floats

  plug(:put_layout, "float.html")

  def index(conn, _params) do
    count_debit = Floats.get_debit!()
    count_credit = Floats.get_credit!()
    list_debit = Floats.list_5_debit!()
    list_credit = Floats.list_5_credit!()
    accounts = Floats.get_count_accounts()

    render(
      conn,
      "dashboard.html",
      accounts: accounts,
      count_debit: count_debit,
      count_credit: count_credit,
      list_debit: list_debit,
      list_credit: list_credit
    )
  end
end
