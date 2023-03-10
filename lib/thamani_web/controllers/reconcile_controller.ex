defmodule ThamaniWeb.ReconcileController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Batches.Batch
  alias Thamani.Inventories
  alias Thamani.Retail_Returns
  alias Thamani.Returns
  alias Thamani.Manufacturer_orders
  alias Thamani.Retman_orders
  alias Thamani.Items
  alias Thamani.Repo

  plug(:put_layout, "dashboard.html")
  plug(:scrub_params, "reconcile" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    if current_user.id == user.id do
      batch =
        user
        |> user_batch
        |> Repo.all()
        |> Repo.preload(:sku)

      count_stock = Inventories.get_count_restock_man(current_user)
      count_order = Manufacturer_orders.get_count_order(current_user)
      count_order_retman = Retman_orders.get_count_order(current_user)
      count_return = Returns.get_count_recieved(current_user)
      count_return_retail = Retail_Returns.get_count_recieved(current_user)

      render(
        conn,
        "index.html",
        batch: batch,
        loader_class: " ",
        loader_class2: " ",
        message_class: " ",
        list_users: [],
        count_sales: " ",
        sum_sales: " ",
        date_0: " ",
        date_01: " ",
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return: count_return,
        count_return_retail: count_return_retail
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: batch_path(conn, :index))
    end
  end

  def new(conn, params, current_user) do
    bat = Items.get_items(current_user)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:batches)
      |> Batch.changeset(params)

    render(
      conn,
      "new.html",
      changeset: changeset,
      bat: bat,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return: count_return,
      count_return_retail: count_return_retail
    )
  end

  def create(conn, %{"batch" => batch_params}, current_user) do
    bat = Items.get_items(current_user)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:batches)
      |> Batch.changeset(batch_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "batch created successfully.")
        |> redirect(to: batch_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          bat: bat,
          count_stock: count_stock,
          count_order: count_order,
          count_order_retman: count_order_retman,
          count_return: count_return,
          count_return_retail: count_return_retail
        )
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user

    batch =
      user
      |> user_batch_by_id(id)
      |> Repo.preload(:sku)

    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    if batch do
      render(
        conn,
        "show.html",
        batch: batch,
        user: user,
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return: count_return,
        count_return_retail: count_return_retail
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: batch_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    batch =
      current_user
      |> user_batch_by_id(id)

    bat = Items.get_items(current_user)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    if batch do
      changeset = Batch.changeset(batch, %{})

      render(
        conn,
        "edit.html",
        batch: batch,
        changeset: changeset,
        bat: bat,
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return: count_return,
        count_return_retail: count_return_retail
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: batch_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "batch" => batch_params}, current_user) do
    batch =
      current_user
      |> user_batch_by_id(id)

    changeset = Batch.changeset(batch, batch_params)
    bat = Items.get_items(current_user)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "batch updated successfully.")
        |> redirect(to: batch_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          batch: batch,
          changeset: changeset,
          bat: bat,
          count_stock: count_stock,
          count_order: count_order,
          count_order_retman: count_order_retman,
          count_return: count_return,
          count_return_retail: count_return_retail
        )
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    user = current_user

    batch =
      user
      |> user_batch_by_id(id)

    if current_user.id == batch.user_id do
      Repo.delete!(batch)

      conn
      |> put_flash(:info, "batch deleted successfully.")
      |> redirect(to: batch_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this batch")
      |> redirect(to: batch_path(conn, :index))
    end
  end

  defp user_batch(user) do
    Ecto.assoc(user, :batches)
  end

  defp user_batch_by_id(user, id) do
    user
    |> user_batch
    |> Repo.get(id)
  end
end

