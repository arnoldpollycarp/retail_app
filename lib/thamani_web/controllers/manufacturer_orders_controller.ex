defmodule ThamaniWeb.ManufacturerOrdersController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Manufacturer_orders.Manufacturer_order
  alias Thamani.Inventories
  alias Thamani.Dispatches
  alias Thamani.Warehouse_orders
  alias Thamani.Sales
  alias Thamani.Pmasters
  alias Thamani.Inventories
  alias Thamani.Repo

  plug(:put_layout, "warehouse.html")
  plug(:scrub_params, "manufacturer_orders" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    manufacturer_order =
      user
      |> user_manufacturer_order
      |> Repo.all()
      |> Repo.preload(:kcity)
      |> Repo.preload(:sku)
      |> Repo.preload(:pmaster)

    cat = Pmasters.get_items()
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    render(
      conn,
      "index.html",
      manufacturer_order: manufacturer_order,
      cat: cat,
      user: user,
      count_7: count_7,
      count_order: count_order,
      list_item: [],
      list_company: [],
      sku: [],
      list_city: [],
      company: ["none"],
      phone: "loading",
      price: "loading",
      id: ["none"],
      description: ["none"],
      delivery: ["none"],
      min_quantity: ["none"],
      unit: "",
      loader_class: " ",
      field_class: "display:none ",
      field_class2: "display:none ",
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
      count_stock: count_stock
    )
  end

  def new(conn, _params, current_user) do
    user = current_user

    cat = Pmasters.get_items()
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    render(
      conn,
      "new.html",
      cat: cat,
      user: user,
      count_7: count_7,
      count_order: count_order,
      list_item: [],
      list_company: [],
      sku: [],
      list_city: [],
      phone: "loading",
      price: "loading",
      company: ["loading"],
      id: ["loading"],
      delivery: ["loading"],
      description: ["loading"],
      min_quantity: ["loading"],
      unit: "",
      image: "loading",
      loader_class: " ",
      field_class: "display:none ",
      field_class2: "display:none ",
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
      count_stock: count_stock
    )
  end

  def create(
        conn,
        %{
          "manufacturer_orders" => %{
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
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:manufacturer_orders)
      |> Manufacturer_order.changeset(%{
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
        |> redirect(to: manufacturer_orders_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          bat: bat,
          company: company,
          count_7: count_7,
          count_order: count_order,
          count_stock: count_stock
        )
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_order = Warehouse_orders.get_count_order(current_user)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    manufacturer_order =
      user
      |> user_manufacturer_order_by_id(id)
      |> Repo.preload(:sku)
      |> Repo.preload(:kcity)
      |> Repo.preload(:company)
      |> Repo.preload(:pmaster)

    if manufacturer_order do
      render(
        conn,
        "show.html",
        manufacturer_order: manufacturer_order,
        user: user,
        count_7: count_7,
        count_order: count_order,
        count_stock: count_stock
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: manufacturer_orders_path(conn, :index))
    end
  end

  #  def edit(conn, %{"id" => id}, current_user) do
  #        order =
  #          current_user
  #          |> user_manufacturer_order_by_id(id)
  #            bat = Inventories.get_items(current_user)
  #            company = Dispatches.get_company(current_user)
  #            count_7 = Dispatches.get_count_recieved!(current_user.id)
  #             count_stock = Inventories.get_count_restock_warehouse(current_user)
  #          if order do
  #          changeset = Manufacturer_order.changeset(order, %{})
  #          render(conn, "edit.html", order: order, changeset: changeset, bat: bat, company: company, count_7: count_7, count_stock: count_stock)
  #        else
  #          conn
  #          |> put_flash(:error, "Not authorised to access that page")
  #          |> redirect(to: manufacturer_orders_path(conn, :index))
  #        end
  #  end

  def update(
        conn,
        %{
          "id" => id,
          "manufacturer_orders" => %{
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
      |> user_manufacturer_order_by_id(id)

    bat = Inventories.get_items(current_user)
    company = Dispatches.get_company()
    mid = Sales.get_item_manufacturer(gtin)
    count_7 = Dispatches.get_count_recieved!(current_user.id)
    count_stock = Inventories.get_count_restock_warehouse(current_user)

    changeset =
      Manufacturer_order.changeset(order, %{
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
        |> redirect(to: manufacturer_orders_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          order: order,
          changeset: changeset,
          bat: bat,
          company: company,
          count_7: count_7,
          count_stock: count_stock
        )
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    user = current_user

    order =
      user
      |> user_manufacturer_order_by_id(id)

    if current_user.id == order.user_id do
      Repo.delete!(order)

      conn
      |> put_flash(:info, "order deleted successfully.")
      |> redirect(to: manufacturer_orders_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this order")
      |> redirect(to: manufacturer_orders_path(conn, :index))
    end
  end

  defp user_manufacturer_order(user) do
    Ecto.assoc(user, :manufacturer_orders)
  end

  defp user_manufacturer_order_by_id(user, id) do
    user
    |> user_manufacturer_order
    |> Repo.get(id)
  end
end
