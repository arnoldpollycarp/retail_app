defmodule ThamaniWeb.ItemController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Accounts
  alias Thamani.Items.Sku
  alias Thamani.Retail_Returns
  alias Thamani.Returns
  alias Thamani.Inventories
  alias Thamani.Manufacturer_orders
  alias Thamani.Retman_orders
  alias Thamani.Pmasters
  alias Thamani.Repo

  plug(:put_layout, "manufacturer.html")
  plug(:scrub_params, "sku" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user
    cat = Pmasters.get_items()

    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    items =
      user
      |> user_items
      |> Repo.all()
      |> Repo.preload(:pmaster)

    render(
      conn,
      "index.html",
      items: items,
      user: user,
      cat: cat,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return: count_return,
      count_return_retail: count_return_retail,
      loader_class: " ",
      message_class: " ",
      alert_class: " ",
      long_process_button_text: " ",
      item_text: " ",
      price_text: " ",
      quantity_text: " ",
      quantity_unit_text: " ",
      weight_text: " ",
      users: "none",
      access_log: "",
      gtin: "none",
      description: "none",
      title: "List",
      text: "",
      text2: "",
      code_text: ""
    )
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user
    item = user |> user_item_by_id(id) |> Repo.preload(:pmaster)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    render(
      conn,
      "show.html",
      item: item,
      user: user,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return: count_return,
      count_return_retail: count_return_retail
    )
  end

  def new(conn, params, current_user) do
    auser = Accounts.get_users()
    cat = Pmasters.get_items()
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:sku)
      |> Sku.changeset(params)

    render(
      conn,
      "new.html",
      changeset: changeset,
      auser: auser,
      cat: cat,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return: count_return,
      count_return_retail: count_return_retail,
      loader_class: " ",
      long_process_button_text: " ",
      users: ["none"],
      gtin: ["none"],
      description: ["none"],
      title: "List",
      text: "",
      text2: "",
      code_text: ""
    )
  end

  def create(conn, %{"sku" => item_params}, current_user) do
    auser = Accounts.get_users()
    cat = Pmasters.get_items()
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:sku)
      |> Sku.changeset(item_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Item was created successfully")
        |> redirect(to: item_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          auser: auser,
          cat: cat,
          count_stock: count_stock,
          count_order: count_order,
          count_order_retman: count_order_retman,
          count_return: count_return,
          count_return_retail: count_return_retail,
          loader_class: " ",
          long_process_button_text: " ",
          users: ["none"],
          gtin: ["none"],
          description: ["none"],
          title: "List",
          text: "",
          text2: ""
        )
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    item = current_user |> user_item_by_id(id)
    cat = Pmasters.get_items_id()
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)
    auser = Accounts.get_users()
    gtin = Accounts.get_barcode(current_user)

    if item do
      changeset = Sku.changeset(item, %{})

      render(
        conn,
        "edit.html",
        item: item,
        changeset: changeset,
        gtin: gtin,
        cat: cat,
        auser: auser,
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return: count_return,
        count_return_retail: count_return_retail
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access this page")
      |> redirect(to: item_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "sku" => item_params}, current_user) do
    item = current_user |> user_item_by_id(id)
    cat = Pmasters.get_items_id()
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)
    changeset = Sku.changeset(item, item_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Item was updated successfully")
        |> redirect(to: item_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          item: item,
          cat: cat,
          changeset: changeset,
          count_stock: count_stock,
          count_order: count_order,
          count_order_retman: count_order_retman,
          count_return: count_return,
          count_return_retail: count_return_retail
        )
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    user = current_user

    item =
      user
      |> user_item_by_id(id)
      |> Repo.preload(:user)

    if current_user.id == item.user.id || current_user.userlevel do
      Repo.delete!(item)

      conn
      |> put_flash(:info, "Post was deleted successfully")
      |> redirect(to: item_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this post")
      |> redirect(to: item_path(conn, :index))
    end
  end

  defp user_items(user) do
    Ecto.assoc(user, :sku)
  end

  defp user_item_by_id(user, id) do
    user
    |> user_items
    |> Repo.get(id)
  end
end
