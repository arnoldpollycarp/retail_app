defmodule ThamaniWeb.LocationsController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Accounts
   alias Thamani.Kcitys.KCity
   alias Thamani.Kcitys

  alias Thamani.Repo

  plug(:put_layout, "dashboard.html")
  plug(:scrub_params, "k_city" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, params, current_user) do
    if current_user.userlevel do
      kcity = Kcitys.list_kcity()

      # {query, rummage} =
      #   KCity
      #   |> KCity.rummage(params["rummage"])
      #
      # kcity =
      #   query
      #   |> Repo.all()

      render(
        conn,
        "index.html",
        kcity: kcity,


      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: panel_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    if current_user.userlevel do


      kcity = Kcitys.get_k_city!(id)

      render(
        conn,
        "show.html",
        kcity: kcity,

      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: panel_path(conn, :index))
    end
  end

  def new(conn, params, current_user) do
    if current_user.userlevel do
      kcity = Kcitys.list_kcity()

      changeset = Kcitys.change_k_city(%KCity{})


      render(
        conn,
        "new.html",
        changeset: changeset,
        kcity: kcity,

      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: panel_path(conn, :index))
    end
  end

  def create(conn, %{"k_city" => kcity_params}, current_user) do
      kcity = Kcitys.list_kcity()

      case Kcitys.create_k_city(kcity_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Kcitys was created successfully")
        |> redirect(to: locations_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          kcity: kcity,

        )
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    if current_user.userlevel do
      kcity = Kcitys.get_k_city!(id)



      if kcity do
        changeset = KCity.changeset(kcity, %{})

        render(
          conn,
          "edit.html",
          kcity: kcity,
          changeset: changeset,


        )
      else
        conn
        |> put_flash(:error, "Not authorised to access that page")
        |> redirect(to: locations_path(conn, :index, current_user.slug))
      end
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: panel_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "k_city" => code_params}, current_user) do
    kcity = Kcitys.get_k_city!(id)

    changeset = KCity.changeset(kcity, code_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Kcitys was updated successfully")
        |> redirect(to: locations_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          kcity: kcity,
          changeset: changeset,

        )
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    if current_user.userlevel do
      kcity = Kcitys.get_k_city!(id)

      if  current_user.userlevel do
        Repo.delete!(kcity)

        conn
        |> put_flash(:info, "Kcitys was deleted successfully")
        |> redirect(to: locations_path(conn, :index))
      else
        conn
        |> put_flash(:error, "You can’t delete this kcity")
        |> redirect(to: locations_path(conn, :index))
      end
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: panel_path(conn, :index))
    end
  end
end
