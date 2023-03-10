defmodule ThamaniWeb.ReturnController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Returns.Return
  alias Thamani.Dispatches
  alias Thamani.Sales
  alias Thamani.Inventories
  alias Thamani.Warehouse_orders
  alias Thamani.Repo

  plug(:put_layout, "warehouse.html")
  plug(:scrub_params, "return" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    return =
      user
      |> user_return
      |> Repo.all()
      |> Repo.preload(:sku)
      |> Repo.preload(:companies)

    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    render(
      conn,
      "index.html",
      return: return,
      count_7: count_7,
      count_order: count_order,
      user: user,
      count_stock: count_stock
    )
  end

  def new(conn, params, current_user) do
    bat = Dispatches.get_recieved_select(current_user.id)
    company = Dispatches.get_company()
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:returns)
      |> Return.changeset(params)

    render(
      conn,
      "new.html",
      changeset: changeset,
      bat: bat,
      count_7: count_7,
      count_order: count_order,
      company: company,
      count_stock: count_stock
    )
  end

  def create(
        conn,
        %{"return" => %{"gtin" => gtin, "quantity" => quantity, "description" => description}},
        current_user
      ) do
    bat = Dispatches.get_recieved_select(current_user.id)
    company = Dispatches.get_company()
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)
    mid = Sales.get_item_manufacturer(gtin)

    changeset =
      current_user
      |> Ecto.build_assoc(:returns)
      |> Return.changeset(%{
        "gtin" => gtin,
        "quantity" => quantity,
        "company" => mid,
        "description" => description,
        "active" => "false"
      })

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "return created successfully.")
        |> redirect(to: return_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          bat: bat,
          count_7: count_7,
          count_order: count_order,
          company: company,
          count_stock: count_stock
        )
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user

    return =
      user
      |> user_return_by_id(id)
      |> Repo.preload(:sku)
      |> Repo.preload(:companies)

    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    if return do
      render(
        conn,
        "show.html",
        return: return,
        count_7: count_7,
        count_order: count_order,
        user: user,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: return_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    return =
      current_user
      |> user_return_by_id(id)

    bat = Dispatches.get_recieved_select(current_user.id)
    company = Dispatches.get_company()
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    if return do
      changeset = Return.changeset(return, %{})

      render(
        conn,
        "edit.html",
        return: return,
        changeset: changeset,
        bat: bat,
        count_7: count_7,
        count_order: count_order,
        company: company,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: return_path(conn, :index))
    end
  end

  def update(
        conn,
        %{
          "id" => id,
          "return" => %{"gtin" => gtin, "quantity" => quantity, "description" => description}
        },
        current_user
      ) do
    return =
      current_user
      |> user_return_by_id(id)

    bat = Dispatches.get_recieved_select(current_user.id)
    company = Dispatches.get_company()
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)
    mid = Sales.get_item_manufacturer(gtin)

    changeset =
      Return.changeset(return, %{
        "gtin" => gtin,
        "quantity" => quantity,
        "description" => description,
        "company" => mid
      })

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "return updated successfully.")
        |> redirect(to: return_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          return: return,
          changeset: changeset,
          bat: bat,
          count_7: count_7,
          count_order: count_order,
          company: company,
          count_stock: count_stock
        )
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    user = current_user

    return =
      user
      |> user_return_by_id(id)

    if current_user.id == return.user_id do
      Repo.delete!(return)

      conn
      |> put_flash(:info, "return deleted successfully.")
      |> redirect(to: return_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this return")
      |> redirect(to: return_path(conn, :index))
    end
  end

  defp user_return(user) do
    Ecto.assoc(user, :returns)
  end

  defp user_return_by_id(user, id) do
    user
    |> user_return
    |> Repo.get(id)
  end
end
