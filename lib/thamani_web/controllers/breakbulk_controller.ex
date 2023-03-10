defmodule ThamaniWeb.BreakbulkController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Breakbulks
  alias Thamani.Breakbulks.Breakbulk
  alias Thamani.Dispatches
  alias Thamani.Warehouse_orders
  alias Thamani.Inventories

  alias Thamani.Repo
 
  plug(:put_layout, "warehouse.html")
  plug(:scrub_params, "breakbulk" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    if current_user.id == user.id do
      breakbulk =
        user
        |> user_breakbulk
        |> Repo.all()
        |> Repo.preload(:dispatch)

      code = Breakbulks.list_breakbulk!(current_user.id)

      status = Breakbulks.list_breakbulk_active(current_user.id)

      count_7 = Dispatches.get_count_recieved!(current_user.id)
      count_order = Warehouse_orders.get_count_order(current_user)
      count_stock = Inventories.get_count_restock_warehouse(current_user)

      render(
        conn,
        "index.html",
        breakbulk: breakbulk,
        code: code,
        status: status,
        user: user,
        count_7: count_7,
        count_order: count_order,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: breakbulk_path(conn, :index))
    end
  end

  def new(conn, params, current_user) do
    bat = Dispatches.get_recieved_select_all(current_user.id)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:breakbulk)
      |> Breakbulk.changeset(params)

    render(
      conn,
      "new.html",
      changeset: changeset,
      bat: bat,
      count_7: count_7,
      count_order: count_order,
      count_stock: count_stock
    )
  end

  def create(
        conn,
        %{"breakbulk" => %{"active" => active}, "uom" => uom, "quantity" => quantity, "scode" => scode},
        current_user
      ) do
    bat = Dispatches.get_recieved_select(current_user.id)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    alphanumeric = SecureRandom.uuid()
    order_id = String.reverse(alphanumeric) |> String.replace("-", "")

    list_scode =
      scode
      |> Enum.chunk_every(1)
      |> Enum.map(fn [a] -> %{"scode" => a} end)

    list_quantity =
      quantity
      |> Enum.chunk_every(1)
      |> Enum.map(fn [b] -> %{"quantity" => b} end)

    list_uom =
      uom
      |> Enum.chunk_every(1)
      |> Enum.map(fn [c] -> %{"uom" => c} end)

    list =
      Enum.map(
        for {x, y, z} <- Enum.zip([list_scode, list_quantity, list_uom]) do
          Enum.concat([x, y, z])
        end,
        fn x ->
          Enum.into(x, %{"code" => order_id, "active" => active, "user_id" => current_user.id})
        end
      )

    changesets =
      Enum.map(list, fn breakbulk ->
        Breakbulk.changeset(%Breakbulk{}, breakbulk)
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
        |> put_flash(:info, "breakbulk created successfully.")
        |> redirect(to: breakbulk_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          bat: bat,
          count_7: count_7,
          count_order: count_order,
          count_stock: count_stock
        )
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user

    breakbulk =
      user
      |> user_breakbulk_by_id(id)
      |> Repo.preload(:dispatch)

    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    if breakbulk do
      render(
        conn,
        "show.html",
        breakbulk: breakbulk,
        user: user,
        count_7: count_7,
        count_order: count_order,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: breakbulk_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    breakbulk =
      current_user
      |> user_breakbulk_by_id(id)

    bat = Dispatches.get_recieved_select!(current_user.id)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    if breakbulk do
      changeset = Breakbulk.changeset(breakbulk, %{})

      render(
        conn,
        "edit.html",
        breakbulk: breakbulk,
        changeset: changeset,
        bat: bat,
        count_7: count_7,
        count_order: count_order,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: breakbulk_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "breakbulk" => breakbulk_params}, current_user) do
    breakbulk =
      current_user
      |> user_breakbulk_by_id(id)

    changeset = Breakbulk.changeset(breakbulk, breakbulk_params)
    bat = Dispatches.get_recieved_select!(current_user.id)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "breakbulk updated successfully.")
        |> redirect(to: breakbulk_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          breakbulk: breakbulk,
          changeset: changeset,
          bat: bat,
          count_7: count_7,
          count_order: count_order,
          count_stock: count_stock
        )
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    user = current_user

    breakbulk =
      user
      |> user_breakbulk_by_id(id)

    if current_user.id == breakbulk.user_id do
      Repo.delete!(breakbulk)

      conn
      |> put_flash(:info, "breakbulk deleted successfully.")
      |> redirect(to: breakbulk_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this breakbulk")
      |> redirect(to: breakbulk_path(conn, :index))
    end
  end

  defp user_breakbulk(user) do
    Ecto.assoc(user, :breakbulk)
  end

  defp user_breakbulk_by_id(user, id) do
    user
    |> user_breakbulk
    |> Repo.get(id)
  end
end
