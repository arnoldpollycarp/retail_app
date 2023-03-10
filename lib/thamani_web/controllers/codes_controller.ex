defmodule ThamaniWeb.CodesController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Accounts
  alias Thamani.Accounts.User
  alias Thamani.Codes.Code
  alias Thamani.Repo

  plug(:put_layout, "manufacturer.html")
  plug(:scrub_params, "code" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, %{"user_id" => user_id}, current_user) do
    user = User |> Repo.get_by!(slug: user_id)

    if current_user.id == user.id do
      codes =
        user
        |> user_code
        |> Repo.all()
        |> Repo.preload(:barcode)

      render(conn, "index.html", codes: codes, user: user)
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: user_codes_path(conn, :index, current_user.slug))
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}, _current_user) do
    user = User |> Repo.get_by!(slug: user_id)

    codes =
      user
      |> user_code_by_id(id)
      |> Repo.preload(:barcode)

    render(conn, "show.html", codes: codes, user: user)
  end

  def new(conn, params, current_user) do
    gtin = Accounts.get_barcode(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:codes)
      |> Code.changeset(params)

    render(conn, "new.html", changeset: changeset, gtin: gtin)
  end

  def create(conn, %{"code" => codes_params}, current_user) do
    gtin = Accounts.get_barcode(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:codes)
      |> Code.changeset(codes_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Code was created successfully")
        |> redirect(to: user_codes_path(conn, :index, current_user.slug))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, gtin: gtin)
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    codes =
      current_user
      |> user_code_by_id(id)

    gtin = Accounts.get_barcode(current_user)

    if codes do
      changeset = Code.changeset(codes, %{})
      render(conn, "edit.html", codes: codes, changeset: changeset, gtin: gtin)
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: user_codes_path(conn, :index, current_user.slug))
    end
  end

  def update(conn, %{"id" => id, "code" => code_params}, current_user) do
    codes = current_user |> user_code_by_id(id)
    changeset = Code.changeset(codes, code_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Code was updated successfully")
        |> redirect(to: user_codes_path(conn, :index, current_user.slug))

      {:error, changeset} ->
        render(conn, "edit.html", codes: codes, changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => id}, current_user) do
    user = User |> Repo.get_by!(slug: user_id)
    codes = user |> user_code_by_id(id) |> Repo.preload(:barcode)

    if current_user.id == codes.user_id || current_user.userlevel do
      Repo.delete!(codes)

      conn
      |> put_flash(:info, "Code was deleted successfully")
      |> redirect(to: user_codes_path(conn, :index, user))
    else
      conn
      |> put_flash(:error, "You can’t delete this code")
      |> redirect(to: user_codes_path(conn, :index, user))
    end
  end

  defp user_code(user) do
    Ecto.assoc(user, :codes)
  end

  defp user_code_by_id(user, id) do
    user
    |> user_code
    |> Repo.get(id)
  end
end
