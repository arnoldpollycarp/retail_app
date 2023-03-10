defmodule ThamaniWeb.DebitController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller

  alias Thamani.Accounts.User
  alias Thamani.Floats
  alias Thamani.Sales
  alias Thamani.Repo

  plug(:put_layout, "float.html")
  plug(:scrub_params, "float" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, %{"user_id" => user_id}, current_user) do
    user = User |> Repo.get_by!(slug: user_id)
    debit = Sales.list_sales_by_mode()
    count_debit = Floats.get_debit(current_user)
    count_credit = Floats.get_credit(current_user)
    list_debit = Floats.list_5_debit(current_user)
    list_credit = Floats.list_5_credit(current_user)

    render(
      conn,
      "index.html",
      debit: debit,
      user: user,
      count_debit: count_debit,
      count_credit: count_credit,
      list_debit: list_debit,
      list_credit: list_credit
    )
  end

  def show(conn, %{"user_id" => user_id, "id" => id}, current_user) do
    user = User |> Repo.get_by!(slug: user_id)
    count_debit = Floats.get_debit(current_user)
    count_credit = Floats.get_credit(current_user)
    list_debit = Floats.list_5_debit(current_user)
    list_credit = Floats.list_5_credit(current_user)

    debit =
      user
      |> user_code_by_id(id)

    render(
      conn,
      "show.html",
      debit: debit,
      user: user,
      count_debit: count_debit,
      count_credit: count_credit,
      list_debit: list_debit,
      list_credit: list_credit
    )
  end

  defp user_code(user) do
    Ecto.assoc(user, :sales)
  end

  defp user_code_by_id(user, id) do
    user
    |> user_code
    |> Repo.get(id)
  end
end
