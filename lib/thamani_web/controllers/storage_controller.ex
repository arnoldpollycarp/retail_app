defmodule ThamaniWeb.StorageController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Storages.Storage
  alias Thamani.Dispatches
  alias Thamani.Inventories
  alias Thamani.Warehouse_orders
  alias Thamani.Repo

  plug(:put_layout, "warehouse.html")
  plug(:scrub_params, "storage" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    storage =
      user
      |> user_storage
      |> Repo.all()
      |> Repo.preload(:sku)
      |> Repo.preload(:dispatch)

    render(
      conn,
      "index.html",
      storage: storage,
      count_7: count_7,
      count_order: count_order,
      user: user,
      count_stock: count_stock
    )
  end

  def new(conn, params, current_user) do
    bat = Dispatches.get_recieved_select(current_user.id)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:storages)
      |> Storage.changeset(params)

    render(
      conn,
      "new.html",
      changeset: changeset,
      count_7: count_7,
      count_order: count_order,
      bat: bat,
      count_stock: count_stock
    )
  end

  def create(
        conn,
        %{
          "storage" => %{
            "name" => name,
            "serial" => serial,
            "description" => description,
            "active" => active
          }
        },
        current_user
      ) do
    bat = Dispatches.get_recieved_select(current_user.id)
    item = Dispatches.get_recieved_item(serial)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:storages)
      |> Storage.changeset(%{
        "name" => name,
        "item" => item,
        "serial" => serial,
        "description" => description,
        "active" => active
      })

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "storage created successfully.")
        |> redirect(to: storage_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          count_7: count_7,
          count_order: count_order,
          bat: bat,
          count_stock: count_stock
        )
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user

    storage =
      user
      |> user_storage_by_id(id)
      |> Repo.preload(:sku)
      |> Repo.preload(:dispatch)

    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    if storage do
      render(
        conn,
        "show.html",
        storage: storage,
        count_7: count_7,
        count_order: count_order,
        user: user,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: storage_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    storage =
      current_user
      |> user_storage_by_id(id)

    bat = Dispatches.get_recieved_select(current_user.id)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    if storage do
      changeset = Storage.changeset(storage, %{})

      render(
        conn,
        "edit.html",
        storage: storage,
        changeset: changeset,
        count_order: count_order,
        count_7: count_7,
        bat: bat,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: storage_path(conn, :index))
    end
  end

  def update(
        conn,
        %{
          "id" => id,
          "storage" => %{
            "name" => name,
            "serial" => serial,
            "description" => description,
            "active" => active
          }
        },
        current_user
      ) do
    item = Dispatches.get_recieved_item(serial)
    bat = Dispatches.get_recieved_select(current_user.id)
    storage =
      current_user
      |> user_storage_by_id(id)

    changeset =
      Storage.changeset(storage, %{
        "name" => name,
        "item" => item,
        "serial" => serial,
        "description" => description,
        "active" => active
      })

    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "storage updated successfully.")
        |> redirect(to: storage_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          storage: storage,
          count_7: count_7,
            bat: bat,
          count_order: count_order,
          changeset: changeset,
          count_stock: count_stock
        )
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    user = current_user

    storage =
      user
      |> user_storage_by_id(id)

    if current_user.id == storage.user_id do
      Repo.delete!(storage)

      conn
      |> put_flash(:info, "storage deleted successfully.")
      |> redirect(to: storage_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this storage")
      |> redirect(to: storage_path(conn, :index))
    end
  end

  defp user_storage(user) do
    Ecto.assoc(user, :storages)
  end

  defp user_storage_by_id(user, id) do
    user
    |> user_storage
    |> Repo.get(id)
  end
end
