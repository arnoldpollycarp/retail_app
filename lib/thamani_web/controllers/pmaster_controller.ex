defmodule ThamaniWeb.PmasterController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Pmasters
  alias Thamani.Pmasters.Pmaster
  alias Thamani.Repo

  plug(:put_layout, "dashboard.html")
  plug(:scrub_params, "pmaster" when action in [:create, :update])

  def index(conn, _params) do
    pmaster = Pmasters.list_pmaster()
    render(conn, "index.html", pmaster: pmaster)
  end

  def show(conn, %{"id" => id}) do
    pmaster = Pmasters.get_pmaster!(id)

    render(conn, "show.html", pmaster: pmaster)
  end

  def new(conn, _params) do
    changeset = Pmasters.change_pmaster(%Pmaster{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"pmaster" => pmaster_params}) do
    case Pmasters.create_pmaster(pmaster_params) do
      {:ok, _pmaster} ->
        conn
        |> put_flash(:info, "Item was created successfully")
        |> redirect(to: pmaster_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    pmaster = Pmasters.get_pmaster!(id)

    if pmaster do
      changeset = Pmasters.change_pmaster(pmaster)
      render(conn, "edit.html", pmaster: pmaster, changeset: changeset)
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: pmaster_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "pmaster" => pmaster_params}) do
    pmaster = Pmasters.get_pmaster!(id)

    case Pmasters.update_pmaster(pmaster, pmaster_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Item was updated successfully")
        |> redirect(to: pmaster_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", pmaster: pmaster, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pmaster = Pmasters.get_pmaster!(id)

    Repo.delete!(pmaster)

    conn
    |> put_flash(:info, "Item was deleted successfully")
    |> redirect(to: pmaster_path(conn, :index))
  end
end
