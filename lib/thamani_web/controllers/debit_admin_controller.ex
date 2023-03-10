defmodule ThamaniWeb.DebitAdminController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Floats

  plug(:put_layout, "float.html")

  def index(conn, _params) do
    float = Floats.list_float()
    count_debit = Floats.get_debit!()
    count_credit = Floats.get_credit!()
    list_debit = Floats.list_5_debit!()
    list_credit = Floats.list_5_credit!()
    accounts = Floats.get_count_accounts()

    render(
      conn,
      "index.html",
      float: float,
      accounts: accounts,
      count_debit: count_debit,
      count_credit: count_credit,
      list_debit: list_debit,
      list_credit: list_credit
    )
  end

  def show(conn, %{"id" => id}) do
    float = Floats.get_float!(id)
    count_debit = Floats.get_debit!()
    count_credit = Floats.get_credit!()
    list_debit = Floats.list_5_debit!()
    list_credit = Floats.list_5_credit!()
    accounts = Floats.get_count_accounts()

    if float do
      render(
        conn,
        "show.html",
        float: float,
        accounts: accounts,
        count_debit: count_debit,
        count_credit: count_credit,
        list_debit: list_debit,
        list_credit: list_credit
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: float_admin_path(conn, :index))
    end
  end
end
