defmodule ThamaniWeb.ReorderController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Inventories
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches_Retailer
  alias Thamani.Reorders.Reorder
  alias Thamani.Repo
  plug(:put_layout, "retail.html")
  plug(:scrub_params, "reorder" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    reorder =
      user
      |> user_reorder
      |> Repo.all()
      |> Repo.preload(:sku)
      |> Repo.preload(:manufacturer)
      |> Repo.preload(:warehouse)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    render(
      conn,
      "index.html",
      reorder: reorder,
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
      |> Ecto.build_assoc(:reorders)
      |> Reorder.changeset(params)

    render(
      conn,
      "new.html",
      changeset: changeset,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6
    )
  end

  def create(conn, %{"reorder" => reorder_params}, current_user) do
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)
    IO.inspect(reorder_params)

    changeset =
      current_user
      |> Ecto.build_assoc(:reorders)
      |> Reorder.changeset(reorder_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "reorder created successfully.")
        |> redirect(to: reorder_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
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

  def show(conn, %{"id" => id}, current_user) do
    user = current_user

    reorder =
      user
      |> user_reorder_by_id(id)
      |> Repo.preload(:sku)
      |> Repo.preload(:manufacturer)
      |> Repo.preload(:warehouse)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    if reorder do
      render(
        conn,
        "show.html",
        reorder: reorder,
        user: user,
        count_4: count_4,
        count_5: count_5,
        count_6: count_6
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: reorder_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    reorder =
      current_user
      |> user_reorder_by_id(id)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    if reorder do
      changeset = Reorder.changeset(reorder, %{})

      render(
        conn,
        "edit.html",
        reorder: reorder,
        changeset: changeset,
        count_4: count_4,
        count_5: count_5,
        count_6: count_6
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: reorder_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "reorder" => reorder_params}, current_user) do
    reorder =
      current_user
      |> user_reorder_by_id(id)

    changeset = Reorder.changeset(reorder, reorder_params)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "reorder updated successfully.")
        |> redirect(to: reorder_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          reorder: reorder,
          changeset: changeset,
          count_4: count_4,
          count_5: count_5,
          count_6: count_6
        )
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    user = current_user

    reorder =
      user
      |> user_reorder_by_id(id)

    if current_user.id == reorder.user_id do
      Repo.delete!(reorder)

      conn
      |> put_flash(:info, "reorder deleted successfully.")
      |> redirect(to: reorder_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this reorder")
      |> redirect(to: reorder_path(conn, :index))
    end
  end

  defp user_reorder(user) do
    Ecto.assoc(user, :reorders)
  end

  defp user_reorder_by_id(user, id) do
    user
    |> user_reorder
    |> Repo.get(id)
  end
end
