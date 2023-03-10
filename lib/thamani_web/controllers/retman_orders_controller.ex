defmodule ThamaniWeb.RetmanOrdersController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Manufacturer_orders.Manufacturer_order
  alias Thamani.Inventories
  alias Thamani.Dispatches
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches_Retailer

  alias Thamani.Sales

  alias Thamani.Pmasters

  alias Thamani.Repo

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "retman_orders" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    retman_order =
      user
      |> user_retman_order
      |> Repo.all()
      |> Repo.preload(:kcity)
      |> Repo.preload(:sku)
      |> Repo.preload(:company)
      |> Repo.preload(:pmaster)

    cat = Pmasters.get_items()
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    render(
      conn,
      "index.html",
      retman_order: retman_order,
      cat: cat,
      user: user,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6,
      list_item: [],
      list_company: [],
      sku: [],
      list_city: [],
      company: ["none"],
      phone: "loading",
      price: "loading",
      id: ["none"],
      delivery: ["none"],
      min_quantity: ["none"],
      loader_class: " ",
      field_class: "display:none ",
      field_class2: "display:none ",
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

    cat = Pmasters.get_items()
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    render(
      conn,
      "new.html",
      cat: cat,
      user: user,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6,
      list_item: [],
      list_company: [],
      sku: [],
      list_city: [],
      company: ["loading"],
      phone: "loading",
      price: "loading",
      id: ["loading"],
      delivery: ["loading"],
      min_quantity: ["loading"],
      unit: "",
      company: ["loading"],
      description: ["loading"],
      loader_class: " ",
      field_class: "display:none ",
      field_class2: "display:none ",
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
      quantity_text: " "
    )
  end

  def create(
        conn,
        %{
          "retman_orders" => %{
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
      |> Ecto.build_assoc(:retman_orders)
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
        |> redirect(to: retman_orders_path(conn, :index))

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

    retman_order =
      user
      |> user_retman_order_by_id(id)
      |> Repo.preload(:sku)
      |> Repo.preload(:kcity)
      |> Repo.preload(:company)
      |> Repo.preload(:pmaster)

    if retman_order do
      render(
        conn,
        "show.html",
        retman_order: retman_order,
        user: user,
        count_4: count_4,
        count_5: count_5,
        count_6: count_6
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: retman_orders_path(conn, :index))
    end
  end

  #  def edit(conn, %{"id" => id}, current_user) do
  #        order =
  #          current_user
  #          |> user_retman_order_by_id(id)
  #            bat = Inventories.get_items(current_user)
  #            company = Dispatches.get_company(current_user)
  #            count_7 = Dispatches.get_count_recieved!(current_user.id)
  #          if order do
  #          changeset = Manufacturer_order.changeset(order, %{})
  #          render(conn, "edit.html", order: order, changeset: changeset, bat: bat, company: company, count_7: count_7)
  #        else
  #          conn
  #          |> put_flash(:error, "Not authorised to access that page")
  #          |> redirect(to: user_retman_orders_path(conn, :index, current_user.slug))
  #        end
  #  end

  def update(
        conn,
        %{
          "id" => id,
          "retman_orders" => %{
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
      |> user_retman_order_by_id(id)

    bat = Inventories.get_items(current_user)
    company = Dispatches.get_company()
    mid = Sales.get_item_manufacturer(gtin)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

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
        |> redirect(to: retman_orders_path(conn, :index))

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
      |> user_retman_order_by_id(id)

    if current_user.id == order.user_id do
      Repo.delete!(order)

      conn
      |> put_flash(:info, "order deleted successfully.")
      |> redirect(to: retman_orders_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this order")
      |> redirect(to: retman_orders_path(conn, :index))
    end
  end

  defp user_retman_order(user) do
    Ecto.assoc(user, :retman_orders)
  end

  defp user_retman_order_by_id(user, id) do
    user
    |> user_retman_order
    |> Repo.get(id)
  end
end
