defmodule ThamaniWeb.UserController do
  use ThamaniWeb, :controller
  require Ecto.Query
  use Rummage.Phoenix.Controller
  alias Thamani.Accounts
  alias Thamani.Accounts.User
  alias Thamani.Repo

  plug(:put_layout, "panel.html")
  plug(:scrub_params, "user" when action in [:create])

  def index(conn, params) do
    {query, rummage} =
      User
      |> User.rummage(params["rummage"])

    users =
      query
      |> Repo.all()

    render(conn, "index.html", access_log: "", users: users, rummage: rummage)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
      changeset = Accounts.change_user(user)
    render(conn, "show.html", user: user, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)

    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
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
