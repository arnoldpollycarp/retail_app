defmodule ThamaniWeb.RegisterController do
  use ThamaniWeb, :controller

  alias Thamani.Accounts
  alias Thamani.Accounts.User
  alias Thamani.Mailer
  alias Thamani.Kcitys
  plug(:put_layout, "lrp.html")
  plug(:scrub_params, "session" when action in ~w(create)a)

  def index(conn, _params) do
    changeset = Accounts.change_user(%User{})
    list_city = Kcitys.list_cities()
    render(conn, "index.html", changeset: changeset, list_city: list_city)
  end

  def send_email_notification(email, code) do
    Mailer.welcome_email(email, code)
  end

  def create(conn, %{
        "session" => %{
          "firstname" => firstname,
          "lastname" => lastname,
          "email" => email,
          "phone" => phone,
          "company" => company,
          "location" => location,
          "password" => password,
          "password_confirmation" => password_confirmation
        }
      }) do
    count = Accounts.get_count_users()
    list_city = Kcitys.list_cities()

    code =
      (SecureRandom.uuid() |> String.replace("-", "") |> String.slice(0..9)) <>
        to_string(count + 1)

    case Accounts.create_user(%{
           "firstname" => firstname,
           "lastname" => lastname,
           "email" => email,
           "phone" => phone,
           "company" => String.downcase(company),
           "location" => location,
           "password" => password,
           "password_confirmation" => password_confirmation,
           "registercode" => code,
          
         }) do
      {:ok, _user} ->
        send_email_notification(email, code)

        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: login_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", changeset: changeset, list_city: list_city)
    end
  end
end
