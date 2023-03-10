defmodule ThamaniWeb.SaleDashboardApiController do
  use ThamaniWeb, :controller
  alias ThamaniWeb.ErrorView
  alias Thamani.Sales
  alias Thamani.Accounts

  def index(conn, %{"security_key" => security_key}) do
    date = String.slice(to_string(DateTime.utc_now()), 0..9)
    users = Accounts.list_users()

    if security_key == Application.get_env(:mpesa_elixir, :keylock) do
      conn
      |> put_status(200)
      |> render("index.json", users: users, date: date)
    else
      conn
      |> put_status(404)
      |> render(ErrorView, "404.json", error: "Not found")
    end
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

  def create(conn, _params) do
    HTTPotion.start()
    {:ok, params, conn} = read_body(conn)

    body = Poison.decode!(params)

    account = get_in(body, ["account_number"])
    security = get_in(body, ["security_key"])

    account_number = Accounts.get_id(account)

    if security == Application.get_env(:mpesa_elixir, :keylock) do
      if is_nil(account_number) do
        send_resp(conn, 403, "That account number you entered does not exist")
      else
        user = Accounts.get_user(account_number)

        data = %{
          account_number: user.account_number,
          account_name: user.firstname <> " " <> user.lastname,
          company: user.company,
          date: String.slice(to_string(DateTime.utc_now()), 0..9),
          Total: count_7(user.id) + count_8(user.id) + count_9(user.id)
        }

        put_resp_content_type(conn, "application/json")
        send_resp(conn, 200, Poison.encode!(data))
      end
    else
      send_resp(conn, 401, "The security key entered is wrong")
    end
  end

  def show(conn, %{"security_key" => security_key, "account_number" => account_number}) do
    date = String.slice(to_string(DateTime.utc_now()), 0..9)

    user =
      case Accounts.get_id(account_number) do
        nil -> Accounts.get_user(account_number)
        _ -> Accounts.get_user(Accounts.get_id(account_number))
      end

    if security_key == Application.get_env(:mpesa_elixir, :keylock) do
      conn
      |> put_status(200)
      |> put_status(400)
      |> render("show.json", user: user, date: date)
    else
      conn
      |> put_status(404)
      |> render(ErrorView, "404.json", error: "Not found")
    end
  end
end
