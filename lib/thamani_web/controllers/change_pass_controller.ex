defmodule ThamaniWeb.ChangePassController do
  use ThamaniWeb, :controller
  use Rummage.Phoenix.Controller
  alias Thamani.Accounts
  alias Thamani.Accounts.User
  alias Thamani.Mailer
  alias Thamani.Repo
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  plug(:scrub_params, "user" when action in [ :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def edit(conn, %{"id" => id}, current_user) do

    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)

    if user = "true" do
      render(conn, "edit.html", user: user, changeset: changeset)
    else
      conn
      |> put_flash(:info, "Code you entered is wrong.")
      |> redirect(to: user_path(conn, :show, user))
    end
  end


  def update(conn, %{
       "id" => id,
        "user" => %{"old_password" => old_password, "password" => password, "password_confirmation" => password_confirmation}
      },current_user) do
    user = Accounts.get_user!(id)

    changeset = Accounts.change_user(user)

    case checkpw(old_password, user.password)  do

      true ->
        Accounts.update_user(user, %{
               "password" => password,
               "password_confirmation" => password_confirmation
             })
        conn
        |> put_flash(:info, "Password changed successfully.")
        |> redirect(to: user_path(conn, :show, user))

      _ ->
        conn
        |> put_flash(:error, "Your value for current password is not the current password")
        |> redirect(to: user_path(conn, :show, user))

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
