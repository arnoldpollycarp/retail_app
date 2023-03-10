defmodule ThamaniWeb.InventoryController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Inventories
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches
  alias Thamani.Dispatches_Retailer
  alias Thamani.Sales
  alias Thamani.Inventories.Inventory
  alias Thamani.Pmasters
  alias Thamani.Discounts
  alias Thamani.Repo

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "inventory" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    # inventorys =
    #   user
    #   |> user_inventory
    #   |> Repo.all()
    #   |> Repo.preload(:sku)
    #   |> Repo.preload(:discounts)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)
    inventory = Inventories.list_inventories(current_user)

    sum_1 =
      case Inventories.get_sum_inventory_price(current_user) do
        nil -> 0.0
        _ -> Inventories.get_sum_inventory_price(current_user)
      end

    sum_2 =
      case Inventories.get_sum_quantity_sales(current_user) do
        nil -> 0.0
        _ -> Inventories.get_sum_quantity_sales(current_user)
      end

    render(
      conn,
      "index.html",
      inventory: inventory,
      user: user,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6,
      sum_1: sum_1,
      sum_2: sum_2,
      loader_class: " ",
      field_class: "display:none ",
      field_class2: "display:none ",
      loader_class2: " ",
      loader_class3: " ",
      message_class: " ",
      alert_class: " ",
      long_process_button_text: " ",
      item_text: " ",
      price_text: " "
    )
  end

  def new(conn, params, current_user) do
    bat = Inventories.get_items(current_user)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    changeset =
      current_user
      |> Ecto.build_assoc(:inventories)
      |> Inventory.changeset(params)

    render(
      conn,
      "new.html",
      changeset: changeset,
      bat: bat,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6,
      items: [],
      items_details: [],
      loader_class: " ",
      field_class: "display:none ",
      field_class2: "display:none ",
      loader_class2: " ",
      loader_class3: " ",
      message_class: " ",
      alert_class: " ",
      long_process_button_text: " ",
      item_text: " ",
      price_text: " "
    )
  end

  def create(
        conn,
        %{
          "inventory" => %{
            "item" => item,
            "quantity" => _quantity,
            "price" => price,
            "description" => description,
            "active" => active
          }
        },
        current_user
      ) do
    bat = Inventories.get_items(current_user)

    price_1 = Dispatches.get_price(item)
    mid = Sales.get_item_manufacturer(item)
    wid = Sales.get_item_warehouse(item, current_user)
    qty = Dispatches_Retailer.get_count_quantity_item(current_user, item)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)
    check = Inventories.check_item(item, current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:inventories)
      |> Inventory.changeset(%{
        "item" => item,
        "mid" => mid,
        "manufacturer" => Dispatches.to_integer(price_1),
        "warehouse" => Dispatches_Warehouse.get_warehouse_value(),
        "wid" => wid,
        "gs1" => 10,
        "price" => price,
        "description" => description,
        "quantity" => Dispatches.to_integer(qty),
        "active" => active
      })

    if check == 0 do
      case Repo.insert(changeset) do
        {:ok, _} ->
          conn
          |> put_flash(:info, "inventory created successfully.")
          |> redirect(to: inventory_path(conn, :index))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(
            conn,
            "new.html",
            changeset: changeset,
            bat: bat,
            count_4: count_4,
            count_5: count_5,
            count_6: count_6
          )
      end
    else
      conn
      |> put_flash(:error, "The Item you are adding already exists in your inventory.")
      |> render(
        "new.html",
        changeset: changeset,
        bat: bat,
        count_4: count_4,
        count_5: count_5,
        count_6: count_6
      )
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user

    inventory =
      user
      |> user_inventory_by_id(id)
      |> Repo.preload(:sku)
      |> Repo.preload(:discounts)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)
    item_id = Inventories.get_item_type(id)
    inventories = Inventories.list_inventories_by_item!(current_user, item_id)
    inventories_price = Inventories.list_inventories_by_item_one!(current_user, item_id)

    if inventory do
      render(
        conn,
        "show.html",
        inventory: inventory,
        inventories: inventories,
        inventories_price: inventories_price,
        user: user,
        count_4: count_4,
        count_5: count_5,
        count_6: count_6
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: inventory_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    inventory =
      current_user
      |> user_inventory_by_id(id)
      |> Repo.preload(:sku)

    bat = Inventories.get_items(current_user)
    discount = Discounts.get_items(current_user)
    count_4 = Inventories.get_count_restock(current_user)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)

    if inventory do
      changeset = Inventory.changeset(inventory, %{})

      render(
        conn,
        "edit.html",
        inventory: inventory,
        changeset: changeset,
        bat: bat,
        discount: discount,
        count_4: count_4,
        count_5: count_5,
        count_6: count_6,
        items: [],
        items_details: [],
        loader_class: " ",
        field_class: "display:none ",
        field_class2: "display:none ",
        loader_class2: " ",
        loader_class3: " ",
        message_class: " ",
        alert_class: " ",
        long_process_button_text: " ",
        item_text: " ",
        price_text: " "
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: inventory_path(conn, :index))
    end
  end

  def update(
        conn,
        %{
          "id" => id,
          "inventory" => %{
            "item" => item,
            "price" => price,
            "warehouse" => warehouse,
            "discount" => discount,
            "reorderstock" => reorderstock,
            "reorderlevel" => reorderlevel,
            "description" => description,
            "active" => active
          }
        },
        current_user
      ) do
    inventory =
      current_user
      |> user_inventory_by_id(id)
      |> Repo.preload(:sku)

    bat = Inventories.get_items(current_user)

    min =
      Float.floor(
        Pmasters.get_min(Dispatches.getcategoryname(item)) / 100 *
          (String.to_float(Dispatches.get_price(item)) + Sales.get_gs1_value() +
             Pmasters.get_warehouse_value()),
        2
      )

    max =
      Float.floor(
        Pmasters.get_max(Dispatches.getcategoryname(item)) / 100 *
          (String.to_float(Dispatches.get_price(item)) + Sales.get_gs1_value() +
             Pmasters.get_warehouse_value()),
        2
      )

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    changeset =
      Inventory.changeset(inventory, %{
        "price" => price,
        "warehouse" => warehouse,
        "discount" => discount,
        "reorderstock" => reorderstock,
        "reorderlevel" => reorderlevel,
        "description" => description,
        "active" => active
      })

    if String.to_float(price) <= max do
      case Repo.update(changeset) do
        {:ok, _} ->
          conn
          |> put_flash(:info, "inventory updated successfully.")
          |> redirect(to: inventory_path(conn, :index))

        {:error, changeset} ->
          render(
            conn,
            "edit.html",
            inventory: inventory,
            changeset: changeset,
            bat: bat,
            count_4: count_4,
            count_5: count_5,
            count_6: count_6
          )
      end
    else
      conn
      |> put_flash(:error, "The Price Has exceeded the range of #{min} - #{max}")
      |> redirect(to: inventory_path(conn, :edit, inventory))
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    user = current_user

    inventory =
      user
      |> user_inventory_by_id(id)

    if current_user.id == inventory.user_id do
      Repo.delete!(inventory)

      conn
      |> put_flash(:info, "inventory deleted successfully.")
      |> redirect(to: inventory_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this inventory")
      |> redirect(to: inventory_path(conn, :index))
    end
  end

  defp user_inventory(user) do
    Ecto.assoc(user, :inventories)
  end

  defp user_inventory_by_id(user, id) do
    user
    |> user_inventory
    |> Repo.get(id)
  end
end
