defmodule ThamaniWeb.BatchController do
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

  plug(:put_layout, "manufacturer.html")
  plug(:scrub_params, "batch" when action in [:create, :update])

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

  def new(conn, params, current_user) do
    bat = Items.get_items_datalist(current_user)
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


    def create(conn, %{"batch" => %{"active" => active}, "batches" => batch, "description" => description, "expiry" => expiry, "item" => item, "production" => production, "quantity" => quantity}, current_user) do
      bat = Items.get_items(current_user)
      count_stock = Inventories.get_count_restock_man(current_user)
      count_order = Manufacturer_orders.get_count_order(current_user)
      count_order_retman = Retman_orders.get_count_order(current_user)
      count_return = Returns.get_count_recieved(current_user)
      count_return_retail = Retail_Returns.get_count_recieved(current_user)


      list_item =
          item
          |> Enum.chunk_every(1)
          |> Enum.map(fn [a] -> %{"item" => a} end)


      list_batch =
        batch
        |> Enum.chunk_every(1)
        |> Enum.map(fn [b] -> %{"batch" => b} end)

      list_expiry =
        expiry
        |> Enum.chunk_every(1)
        |> Enum.map(fn [c] -> %{"expiry" => c} end)


      list_production =
            production
            |> Enum.chunk_every(1)
            |> Enum.map(fn [d] -> %{"production" => d} end)

      list_quantity =
            quantity
            |> Enum.chunk_every(1)
            |> Enum.map(fn [e] -> %{"quantity" => e} end)

      list_description =
            description
            |> Enum.chunk_every(1)
            |> Enum.map(fn [f] -> %{"description" => f} end)

      list =
        Enum.map(
          for {a, b, c, d, e, f} <- Enum.zip([list_item, list_batch, list_expiry, list_production, list_quantity, list_description]) do
            Enum.concat([a, b, c, d, e, f])
          end,
          fn x ->
            Enum.into(x, %{"active" => active, "user_id" => current_user.id})
          end
        )

      changesets =
        Enum.map(list, fn batch ->
          Batch.changeset(%Batch{}, batch)
        end)

      result =
        changesets
        |> Enum.with_index()
        |> Enum.reduce(Ecto.Multi.new(), fn {changeset, index}, multi ->
          Ecto.Multi.insert(multi, Integer.to_string(index), changeset)
        end)
        |> Repo.transaction()

      case result do
        {:ok, _multi_order_result} ->
          conn
          |> put_flash(:info, "batches created successfully.")
          |> redirect(to: batch_path(conn, :index))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(
            conn,
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

    bat = Items.get_items_datalist(current_user)
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
    bat = Items.get_items_datalist(current_user)
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
