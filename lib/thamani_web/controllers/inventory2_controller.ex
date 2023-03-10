defmodule ThamaniWeb.Inventory2Controller do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Inventories
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches_Retailer
  alias Thamani.Dispatches
  alias Thamani.Sales
  alias Thamani.Inventories.Inventory
  alias Thamani.Repo

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "inventory" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    inventory =
      user
      |> user_inventory
      |> Repo.all()
      |> Repo.preload(:sku)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    render(
      conn,
      "index.html",
      inventory: inventory,
      user: user,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6,
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
    bat = Inventories.get_items_manufacturer!(current_user)
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
    # check = Inventories.check_item(item, current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:inventories)
      |> Inventory.changeset(%{
        "item" => item,
        "mid" => mid,
        "manufacturer" => Dispatches.to_integer(price_1),
        "warehouse" => 0.5,
        "wid" => wid,
        "gs1" => 10,
        "price" => Dispatches.to_integer(price),
        "description" => description,
        "quantity" => Dispatches.to_integer(qty),
        "active" => active
      })

    # if is_nil(check) do
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

    #   else

    #       conn
    #        |> put_flash(:error, "The Item you are adding already exists in your inventory.")
    #        |> render( "new.html", changeset: changeset, bat: bat, count_4: count_4,count_5: count_5, count_6: count_6)
    #   end
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user

    inventory =
      user
      |> user_inventory_by_id(id)
      |> Repo.preload(:sku)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    if inventory do
      render(
        conn,
        "show.html",
        inventory: inventory,
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

    bat = Inventories.get_items_manufacturer!(current_user)
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    if inventory do
      changeset = Inventory.changeset(inventory, %{})

      render(
        conn,
        "edit.html",
        inventory: inventory,
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
            "category" => category,
            "description" => description,
            "active" => active
          }
        },
        current_user
      ) do
    inventory =
      current_user
      |> user_inventory_by_id(id)

    bat = Inventories.get_items_manufacturer!(current_user)
    qty = Dispatches_Warehouse.get_count_quantity_item_retail(current_user, item)
    price_1 = Dispatches.get_price(item)
    mid = Sales.get_item_manufacturer(item)
    wid = Sales.get_item_warehouse(item, current_user)

    sold = Sales.get_count_quantity_item(current_user, item)

    remain = Dispatches.to_integer(qty) - Dispatches.to_integer(sold)

    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    changeset =
      Inventory.changeset(inventory, %{
        "item" => item,
        "mid" => mid,
        "manufacturer" => Dispatches.to_integer(price_1),
        "warehouse" => 0.5,
        "wid" => wid,
        "gs1" => 10,
        "price" => price,
        "category" => category,
        "description" => description,
        "quantity" => Dispatches.to_integer(qty),
        "sold" => Dispatches.to_integer(sold),
        "remain" => remain,
        "active" => active
      })

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
