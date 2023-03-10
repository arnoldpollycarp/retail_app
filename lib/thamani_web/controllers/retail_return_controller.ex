defmodule ThamaniWeb.RetailReturnController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Retail_Returns.Retail_Return
  alias Thamani.Inventories
  alias Thamani.Dispatches
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches_Retailer
  alias Thamani.Sales
  alias Thamani.Repo

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "retail__return" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    retail_return =
      user
      |> user_retail_return
      |> Repo.all()
      |> Repo.preload(:sku)
      |> Repo.preload(:companies)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    render(
      conn,
      "index.html",
      retail_return: retail_return,
      user: user,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6
    )
  end

  def new(conn, params, current_user) do
    bat = Inventories.get_items!(current_user)
    company = Dispatches.get_company()
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    changeset =
      current_user
      |> Ecto.build_assoc(:retail_returns)
      |> Retail_Return.changeset(params)

    render(
      conn,
      "new.html",
      changeset: changeset,
      bat: bat,
      company: company,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6
    )
  end

  def create(
        conn,
        %{
          "retail__return" => %{
            "gtin" => gtin,
            "quantity" => quantity,
            "description" => description,
            "active" => active
          }
        },
        current_user
      ) do
    bat = Inventories.get_items!(current_user)
    company = Dispatches.get_company()
    mid = Sales.get_item_manufacturer(gtin)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    changeset =
      current_user
      |> Ecto.build_assoc(:retail_returns)
      |> Retail_Return.changeset(%{
        "gtin" => gtin,
        "quantity" => quantity,
        "company" => mid,
        "description" => description,
        "active" => active
      })

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "return created successfully.")
        |> redirect(to: retail_return_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          bat: bat,
          company: company,
          count_4: count_4,
          count_5: count_5,
          count_6: count_6
        )
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    retail_return =
      user
      |> user_retail_return_by_id(id)
      |> Repo.preload(:sku)
      |> Repo.preload(:companies)

    if retail_return do
      render(
        conn,
        "show.html",
        retail_return: retail_return,
        user: user,
        count_4: count_4,
        count_5: count_5,
        count_6: count_6
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: retail_return_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    return =
      current_user
      |> user_retail_return_by_id(id)

    bat = Inventories.get_items!(current_user)
    company = Dispatches.get_company()
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    if return do
      changeset = Retail_Return.changeset(return, %{})

      render(
        conn,
        "edit.html",
        return: return,
        changeset: changeset,
        bat: bat,
        company: company,
        count_4: count_4,
        count_5: count_5,
        count_6: count_6
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: retail_return_path(conn, :index))
    end
  end

  def update(
        conn,
        %{
          "id" => id,
          "retail__return" => %{
            "gtin" => gtin,
            "quantity" => quantity,
            "description" => description,
            "active" => active
          }
        },
        current_user
      ) do
    return =
      current_user
      |> user_retail_return_by_id(id)

    bat = Inventories.get_items!(current_user)
    company = Dispatches.get_company()
    mid = Sales.get_item_manufacturer(gtin)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    changeset =
      Retail_Return.changeset(return, %{
        "gtin" => gtin,
        "quantity" => quantity,
        "description" => description,
        "active" => active,
        "company" => mid
      })

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "return updated successfully.")
        |> redirect(to: retail_return_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          return: return,
          changeset: changeset,
          bat: bat,
          company: company,
          count_4: count_4,
          count_5: count_5,
          count_6: count_6
        )
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    user = current_user

    return =
      user
      |> user_retail_return_by_id(id)

    if current_user.id == return.user_id do
      Repo.delete!(return)

      conn
      |> put_flash(:info, "return deleted successfully.")
      |> redirect(to: retail_return_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this return")
      |> redirect(to: retail_return_path(conn, :index))
    end
  end

  defp user_retail_return(user) do
    Ecto.assoc(user, :retail_returns)
  end

  defp user_retail_return_by_id(user, id) do
    user
    |> user_retail_return
    |> Repo.get(id)
  end
end
