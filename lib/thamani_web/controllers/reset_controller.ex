defmodule ThamaniWeb.ResetController do
  use ThamaniWeb, :controller
  use Rummage.Phoenix.Controller
  alias Thamani.Accounts
  alias Thamani.Accounts.User
  alias Thamani.Mailer
  alias Thamani.Email
  alias Thamani.Repo

  plug(:put_layout, "privacy.html")
  plug(:scrub_params, "user" when action in [:create, :update])

  def index(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def send_email_notification(email, code) do
    Mailer.reset_email(email, code)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    user = Repo.get_by(User, email: email)
    count = Accounts.get_count_users()

    code =
      (SecureRandom.uuid() |> String.replace("-", "") |> String.slice(0..9)) <>
        to_string(count + 1)

    token = SecureRandom.urlsafe_base64()

    cond do
      user && user.active == "true" ->
        {:ok, user}
        Accounts.update_user(user, %{"resetcode" => code, "token" => token})
        send_email_notification(email, code)

        conn
        |> put_flash(:info, "Kindly place the reset code sent to your email.")
        |> redirect(to: reset_path(conn, :edit, token))

      true ->
        {:error, :unauthorized}

        conn
        |> put_flash(:error, "The email does not exist")
        |> redirect(to: reset_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => token}) do
    user = Repo.get_by(User, token: token)

    changeset = Accounts.change_user(user)

    if user = "true" do
      render(conn, "edit.html", user: token, changeset: changeset)
    else
      conn
      |> put_flash(:info, "Code you entered is wrong.")
      |> redirect(to: reset_path(conn, :edit, user))
    end
  end

  def update(conn, %{"id" => token, "user" => %{"code" => code}}) do
    user = Repo.get_by(User, token: token)
    check = Accounts.check_code_reset(token, code)
    changeset = Accounts.change_user(user)

    if check == 0 do
      conn
      |> put_flash(:error, "The code you entered is invalid.")
      |> redirect(to: reset_path(conn, :edit, token))
    else
      conn
      |> put_flash(:info, "Reset your password")

      render(conn, "index.html", token: token, changeset: changeset)
    end
  end

  def update(conn, %{
        "id" => token,
        "user" => %{"password" => password, "password_confirmation" => password_confirmation}
      }) do
    user = Repo.get_by(User, token: token)
    changeset = Accounts.change_user(user)

    case Accounts.update_user(user, %{
           "password" => password,
           "password_confirmation" => password_confirmation
         }) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password reset successfully.")
        |> redirect(to: login_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Some error has occured")

        render(conn, "index.html", token: token, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
