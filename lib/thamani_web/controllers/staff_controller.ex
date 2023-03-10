defmodule ThamaniWeb.StaffController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Inventories
  alias Thamani.Staffs.Staff

  alias Thamani.Shops
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches_Retailer
  alias Thamani.Repo

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "staff" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    staff =
      user
      |> user_code
      |> Repo.all()
      |> Repo.preload(:shops)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    render(
      conn,
      "index.html",
      staff: staff,
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

    staff =
      user
      |> user_code_by_id(id)
      |> Repo.preload(:shops)

    render(
      conn,
      "show.html",
      staff: staff,
      user: user,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6
    )
  end

  def new(conn, params, current_user) do
    shop = Shops.list_shop!(current_user)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    changeset =
      current_user
      |> Ecto.build_assoc(:staff)
      |> Staff.changeset(params)

    render(
      conn,
      "new.html",
      changeset: changeset,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6,
      shop: shop
    )
  end

  def create(conn, %{"staff" => staff_params}, current_user) do
    shop = Shops.list_shop!(current_user)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    changeset =
      current_user
      |> Ecto.build_assoc(:staff)
      |> Staff.changeset(staff_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Staff was created successfully")
        |> redirect(to: staff_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          count_4: count_4,
          count_5: count_5,
          count_6: count_6,
          shop: shop
        )
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    staff =
      current_user
      |> user_code_by_id(id)

    shop = Shops.list_shop!(current_user)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    if staff do
      changeset = Staff.changeset(staff, %{})

      render(
        conn,
        "edit.html",
        staff: staff,
        changeset: changeset,
        count_4: count_4,
        count_5: count_5,
        count_6: count_6,
        shop: shop
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: staff_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "staff" => code_params}, current_user) do
    staff = current_user |> user_code_by_id(id)
    shop = Shops.list_shop!(current_user)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)
    changeset = Staff.changeset(staff, code_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Staff was updated successfully")
        |> redirect(to: staff_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          staff: staff,
          changeset: changeset,
          count_4: count_4,
          count_5: count_5,
          count_6: count_6,
          shop: shop
        )
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    user = current_user
    staff = user |> user_code_by_id(id)

    if current_user.id == staff.user_id || current_user.userlevel do
      Repo.delete!(staff)

      conn
      |> put_flash(:info, "Staff was deleted successfully")
      |> redirect(to: staff_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this staff")
      |> redirect(to: staff_path(conn, :index))
    end
  end

  defp user_code(user) do
    Ecto.assoc(user, :staff)
  end

  defp user_code_by_id(user, id) do
    user
    |> user_code
    |> Repo.get(id)
  end
end
