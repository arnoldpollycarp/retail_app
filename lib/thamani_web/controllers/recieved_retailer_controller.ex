defmodule ThamaniWeb.RecievedRetailerController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches_Retailer
  alias Thamani.Dispatches_Warehouse.Dispatch_Warehouse
  alias Thamani.Inventories
  alias Thamani.Breakbulks
  alias Thamani.Repo

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "dispatch__warehouse" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user
    recieved = Dispatches_Warehouse.list_recieved(current_user.id)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    code = Breakbulks.list_breakbulk!(current_user.id)
    status = Breakbulks.list_breakbulk_active(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    if recieved do
      render(
        conn,
        "index.html",
        recieved: recieved,
        user: user,
        code: code,
        status: status,
        count_5: count_5,
        count_4: count_4,
        count_6: count_6
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: recieved_retailer_path(conn, :index))
    end
  end

  def new(conn, _params, _current_user) do
    conn
    |> put_flash(:error, "Not authorised to add to this page")
    |> redirect(to: recieved_retailer_path(conn, :index))
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user
    recieved = Dispatches_Warehouse.get_recieved(current_user.id, id)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    if recieved do
      render(
        conn,
        "show.html",
        recieved: recieved,
        user: user,
        count_5: count_5,
        count_6: count_6,
        count_4: count_4
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: recieved_retailer_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    recieved = Dispatches_Warehouse.get_recieved(current_user.id, id)
    bat = Dispatches_Warehouse.get_items(current_user)
    company = Dispatches_Warehouse.get_company()
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    if recieved do
      changeset = Dispatch_Warehouse.changeset(recieved, %{})

      render(
        conn,
        "edit.html",
        recieved: recieved,
        changeset: changeset,
        bat: bat,
        company: company,
        count_5: count_5,
        count_4: count_4,
        count_6: count_6
      )
    else
      conn
      |> put_flash(:error, "Not authorised to edit this page")
      |> redirect(to: recieved_retailer_path(conn, :index))
    end
  end

  def update(
        conn,
        %{"id" => id, "dispatch__warehouse" => recieved_params},
        current_user
      ) do
    recieved = Dispatches_Warehouse.get_recieved(current_user.id, id)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)
    changeset = Dispatch_Warehouse.changeset(recieved, recieved_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "recieved updated successfully.")
        |> redirect(to: recieved_retailer_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          recieved: recieved,
          changeset: changeset,
          count_5: count_5,
          count_6: count_6,
          count_4: count_4
        )
    end
  end
end
