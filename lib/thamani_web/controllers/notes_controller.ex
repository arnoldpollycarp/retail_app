defmodule ThamaniWeb.NotesController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Inventories
  alias Thamani.Credit_note.Notes
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches_Retailer
  alias Thamani.Repo

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "notes" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    notes =
      user
      |> user_code
      |> Repo.all()

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    render(
      conn,
      "index.html",
      notes: notes,
      user: user,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6
    )
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    notes =
      user
      |> user_code_by_id(id)

    render(
      conn,
      "show.html",
      notes: notes,
      user: user,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6
    )
  end

  def new(conn, params, current_user) do
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    changeset =
      current_user
      |> Ecto.build_assoc(:note)
      |> Notes.changeset(params)

    render(
      conn,
      "new.html",
      changeset: changeset,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6
    )
  end

  def create(conn, %{"notes" => notes_params}, current_user) do
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    changeset =
      current_user
      |> Ecto.build_assoc(:note)
      |> Notes.changeset(notes_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Notes was created successfully")
        |> redirect(to: notes_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          count_4: count_4,
          count_5: count_5,
          count_6: count_6
        )
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    notes =
      current_user
      |> user_code_by_id(id)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    if notes do
      changeset = Notes.changeset(notes, %{})

      render(
        conn,
        "edit.html",
        notes: notes,
        changeset: changeset,
        count_4: count_4,
        count_5: count_5,
        count_6: count_6
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: notes_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "notes" => code_params}, current_user) do
    notes = current_user |> user_code_by_id(id)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)
    changeset = Notes.changeset(notes, code_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Notes was updated successfully")
        |> redirect(to: notes_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          notes: notes,
          changeset: changeset,
          count_4: count_4,
          count_5: count_5,
          count_6: count_6
        )
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    user = current_user
    notes = user |> user_code_by_id(id)

    if current_user.id == notes.user_id || current_user.userlevel do
      Repo.delete!(notes)

      conn
      |> put_flash(:info, "Notes was deleted successfully")
      |> redirect(to: notes_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this notes")
      |> redirect(to: notes_path(conn, :index))
    end
  end

  defp user_code(user) do
    Ecto.assoc(user, :note)
  end

  defp user_code_by_id(user, id) do
    user
    |> user_code
    |> Repo.get(id)
  end
end
