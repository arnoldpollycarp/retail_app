defmodule ThamaniWeb.ShopController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Inventories
  alias Thamani.Shops.Shop
  alias Thamani.Shops
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches_Retailer
  alias Thamani.Repo

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "shop" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    shop =
      user
      |> user_code
      |> Repo.all()
      |> Repo.preload(:kcity)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    render(
      conn,
      "index.html",
      shop: shop,
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

    shop =
      user
      |> user_code_by_id(id)

    render(
      conn,
      "show.html",
      shop: shop,
      user: user,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6
    )
  end

  def new(conn, params, current_user) do
    city = Shops.get_city()
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    changeset =
      current_user
      |> Ecto.build_assoc(:shop)
      |> Shop.changeset(params)

    render(
      conn,
      "new.html",
      changeset: changeset,
      count_4: count_4,
      count_5: count_5,
      city: city,
      count_6: count_6
    )
  end

  def create(conn, %{"shop" => shop_params}, current_user) do
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)
    city = Shops.get_city()

    changeset =
      current_user
      |> Ecto.build_assoc(:shop)
      |> Shop.changeset(shop_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Shop was created successfully")
        |> redirect(to: shop_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          count_4: count_4,
          count_5: count_5,
          count_6: count_6,
          city: city
        )
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    shop =
      current_user
      |> user_code_by_id(id)

    city = Shops.get_city()
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    if shop do
      changeset = Shop.changeset(shop, %{})

      render(
        conn,
        "edit.html",
        shop: shop,
        changeset: changeset,
        count_4: count_4,
        count_5: count_5,
        city: city,
        count_6: count_6
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: shop_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "shop" => code_params}, current_user) do
    city = Shops.get_city()
    shop = current_user |> user_code_by_id(id)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)
    changeset = Shop.changeset(shop, code_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Shop was updated successfully")
        |> redirect(to: shop_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          shop: shop,
          changeset: changeset,
          count_4: count_4,
          count_5: count_5,
          count_6: count_6,
          city: city
        )
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    user = current_user
    shop = user |> user_code_by_id(id)

    if current_user.id == shop.user_id || current_user.userlevel do
      Repo.delete!(shop)

      conn
      |> put_flash(:info, "Shop was deleted successfully")
      |> redirect(to: shop_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this shop")
      |> redirect(to: shop_path(conn, :index))
    end
  end

  defp user_code(user) do
    Ecto.assoc(user, :shop)
  end

  defp user_code_by_id(user, id) do
    user
    |> user_code
    |> Repo.get(id)
  end
end
