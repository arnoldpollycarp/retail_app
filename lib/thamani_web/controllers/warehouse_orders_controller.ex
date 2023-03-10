defmodule ThamaniWeb.WarehouseOrdersController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Warehouse_orders.Warehouse_order
  alias Thamani.Inventories
  alias Thamani.Dispatches
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches_Retailer
  alias Thamani.Sales
  alias Thamani.Pmasters
  alias Thamani.Repo

  plug(:put_layout, "retail.html")

  plug(:scrub_params, "warehouse_orders" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    warehouse_order =
      user
      |> user_warehouse_order
      |> Repo.all()
      |> Repo.preload(:sku)
      |> Repo.preload(:kcity)
      |> Repo.preload(:company)
      |> Repo.preload(:pmaster)

    cat = Pmasters.get_items()
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    render(
      conn,
      "index.html",
      warehouse_order: warehouse_order,
      cat: cat,
      user: user,
      display: [],
      count_4: count_4,
      count_5: count_5,
      count_6: count_6,
      list_item: [],
      list_city: [],
      id: ["none"],
      item_id: [],
      company: ["none"],
      phone: "loading",
      price: "loading",
      delivery: ["none"],
      quantity: "none",
      total: "none",
      used: "none",
      loader_class: " ",
      field_class: "display:none ",
      field_class2: "display:none ",
      description: ["none"],
      image: "loading",
      loader_class2: " ",
      loader_class3: " ",
      message_class: " ",
      alert_class: " ",
      long_process_button_text: " ",
      category_text: " ",
      item_text: " ",
      uom_text: " ",
      quantity_text: " "
    )
  end

  def new(conn, _params, current_user) do
    user = current_user
    bat = Inventories.get_items(current_user)
    company = Dispatches.get_company()
    cat = Pmasters.get_items()
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    render(
      conn,
      "new.html",
      bat: bat,
      user: user,
      cat: cat,
      company: company,
      phone: "loading",
      price: "loading",
      count_4: count_4,
      count_5: count_5,
      count_6: count_6,
      sku: [],
      list_item: [],
      list_company: [],
      list_city: [],
      id: ["loading"],
      item_id: [],
      company: ["loading"],
      delivery: ["loading"],
      company: ["loading"],
      quantity: "none",
      unit: "",
      total: "none",
      used: "none",
      loader_class: " ",
      field_class: "display:none ",
      field_class2: "display:none ",
      description: ["loading"],
      image: "loading",
      loader_class2: " ",
      loader_class3: " ",
      loader_class4: " ",
      message_class: " ",
      alert_class: " ",
      long_process_button_text: " ",
      category_text: " ",
      item_text: " ",
      uom_text: " ",
      quantity_text: " ",
      min_quantity: []
    )
  end

  def create(
        conn,
        %{
          "warehouse_orders" => %{
            "gtin" => gtin,
            "quantity" => quantity,
            "description" => description,
            "active" => active
          }
        },
        current_user
      ) do
    bat = Inventories.get_items(current_user)
    company = Dispatches.get_company()
    mid = Sales.get_item_manufacturer(gtin)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    changeset =
      current_user
      |> Ecto.build_assoc(:warehouse_orders)
      |> Warehouse_order.changeset(%{
        "gtin" => gtin,
        "quantity" => quantity,
        "company" => mid,
        "description" => description,
        "active" => active
      })

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "order created successfully.")
        |> redirect(to: warehouse_orders_path(conn, :index))

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

    warehouse_order =
      user
      |> user_warehouse_order_by_id(id)
      |> Repo.preload(:sku)
      |> Repo.preload(:kcity)
      |> Repo.preload(:company)
      |> Repo.preload(:pmaster)

    if warehouse_order do
      render(
        conn,
        "show.html",
        warehouse_order: warehouse_order,
        user: user,
        count_4: count_4,
        count_5: count_5,
        count_6: count_6
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: warehouse_orders_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    order =
      current_user
      |> user_warehouse_order_by_id(id)

    bat = Inventories.get_items(current_user)
    company = Dispatches.get_company()
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    if order do
      changeset = Warehouse_order.changeset(order, %{})

      render(
        conn,
        "edit.html",
        order: order,
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
      |> redirect(to: warehouse_orders_path(conn, :index))
    end
  end

  def update(
        conn,
        %{
          "id" => id,
          "warehouse_orders" => %{
            "gtin" => gtin,
            "quantity" => quantity,
            "description" => description,
            "active" => active
          }
        },
        current_user
      ) do
    order =
      current_user
      |> user_warehouse_order_by_id(id)

    bat = Inventories.get_items(current_user)
    company = Dispatches.get_company()
    mid = Sales.get_item_manufacturer(gtin)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    changeset =
      Warehouse_order.changeset(order, %{
        "gtin" => gtin,
        "quantity" => quantity,
        "description" => description,
        "active" => active,
        "company" => mid
      })

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "order updated successfully.")
        |> redirect(to: warehouse_orders_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          order: order,
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

    order =
      user
      |> user_warehouse_order_by_id(id)

    if current_user.id == order.user_id do
      Repo.delete!(order)

      conn
      |> put_flash(:info, "order deleted successfully.")
      |> redirect(to: warehouse_orders_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this order")
      |> redirect(to: warehouse_orders_path(conn, :index))
    end
  end

  defp user_warehouse_order(user) do
    Ecto.assoc(user, :warehouse_orders)
  end

  defp user_warehouse_order_by_id(user, id) do
    user
    |> user_warehouse_order
    |> Repo.get(id)
  end
end
