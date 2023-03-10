defmodule ThamaniWeb.LoginController do
  use ThamaniWeb, :controller

  plug(:put_layout, "lrp.html")
  plug(:scrub_params, "session" when action in ~w(create)a)

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case ThamaniWeb.Auth.login_by_email_and_pass(conn, email, password) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You’re now logged in!")
        |> redirect(to: panel_path(conn, :index))

      {:error, :unauthorized, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("index.html")
    end
  end

  def delete(conn, _) do
    conn
    |> ThamaniWeb.Auth.logout()
    |> put_flash(:info, "You have logged out!")
    |> redirect(to: page_path(conn, :index))
  end
end
