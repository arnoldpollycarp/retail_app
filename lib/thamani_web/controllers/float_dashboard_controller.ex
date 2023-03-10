defmodule ThamaniWeb.FloatDashboardController do
  use ThamaniWeb, :controller

  require Ecto.Query
  require Ecto
  require Ecto.Schema

  alias Thamani.Floats

  plug(:put_layout, "float.html")

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, params, current_user) do
    user = current_user.slug
    IO.inspect(params)
    count_debit = Floats.get_debit(current_user)
    count_credit = Floats.get_credit(current_user)
    list_debit = Floats.list_5_debit(current_user)
    list_credit = Floats.list_5_credit(current_user)

    render(
      conn,
      "dashboard.html",
      user: user,
      count_debit: count_debit,
      count_credit: count_credit,
      list_debit: list_debit,
      list_credit: list_credit,
      params: params
    )
  end
end
