defmodule ThamaniWeb.InvoiceController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Invoicing
  alias Thamani.Invoicing.Invoice
  alias Thamani.Inventories
  alias Thamani.Retail_Returns
  alias Thamani.Returns
  alias Thamani.Manufacturer_orders
  alias Thamani.Retman_orders
  alias Thamani.Items
  alias Thamani.Repo

  plug(:put_layout, "manufacturer.html")
  plug(:scrub_params, "invoice" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user
    invoice = Invoicing.list_invoice(user.id)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    render(
      conn,
      "index.html",
      invoice: invoice,
      user: user,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return: count_return,
      count_return_retail: count_return_retail,
      loader_class: " ",
      loader_class2: " ",
      message_class: " ",
      list_sales: [],
      list_sales_uniq: [],
      count_sales: 0,
      sum_sales: 0.0,
      long_process_button_text: " ",
      date: " ",
      date_1: " ",
      date_0: " ",
      date_01: " "
    )
  end

  def new(conn, params, current_user) do
    bat = Items.get_items(current_user)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:invoice)
      |> Invoice.changeset(params)

    render(
      conn,
      "new.html",
      changeset: changeset,
      bat: bat,
      count_stock: count_stock,
      count_order: count_order,
      count_order_retman: count_order_retman,
      count_return: count_return,
      count_return_retail: count_return_retail,
      loader_class: " ",
      loader_class2: " ",
      message_class: " ",
      list_sales: [],
      list_sales_uniq: [],
      count_sales: 0,
      sum_sales: 0.0,
      long_process_button_text: " ",
      date: " ",
      date_1: " ",
      date_0: " ",
      date_01: " "
    )
  end

  def create(conn, %{"invoice" => invoice_params}, current_user) do
    bat = Items.get_items(current_user)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)
    IO.inspect(invoice_params)

    changeset =
      current_user
      |> Ecto.build_assoc(:invoice)
      |> Invoice.changeset(invoice_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "invoice created successfully.")
        |> redirect(to: invoice_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          bat: bat,
          count_stock: count_stock,
          count_order: count_order,
          count_order_retman: count_order_retman,
          count_return: count_return,
          count_return_retail: count_return_retail
        )
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user

    invoice =
      user
      |> user_invoice_by_id(id)

    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    if invoice do
      render(
        conn,
        "show.html",
        invoice: invoice,
        user: user,
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return: count_return,
        count_return_retail: count_return_retail
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: invoice_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    invoice =
      current_user
      |> user_invoice_by_id(id)

    bat = Items.get_items(current_user)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    if invoice do
      changeset = Invoice.changeset(invoice, %{})

      render(
        conn,
        "edit.html",
        invoice: invoice,
        changeset: changeset,
        bat: bat,
        count_stock: count_stock,
        count_order: count_order,
        count_order_retman: count_order_retman,
        count_return: count_return,
        count_return_retail: count_return_retail
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: invoice_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "invoice" => invoice_params}, current_user) do
    invoice =
      current_user
      |> user_invoice_by_id(id)

    changeset = Invoice.changeset(invoice, invoice_params)
    bat = Items.get_items(current_user)
    count_stock = Inventories.get_count_restock_man(current_user)
    count_order = Manufacturer_orders.get_count_order(current_user)
    count_order_retman = Retman_orders.get_count_order(current_user)
    count_return = Returns.get_count_recieved(current_user)
    count_return_retail = Retail_Returns.get_count_recieved(current_user)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "invoice updated successfully.")
        |> redirect(to: invoice_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          invoice: invoice,
          changeset: changeset,
          bat: bat,
          count_stock: count_stock,
          count_order: count_order,
          count_order_retman: count_order_retman,
          count_return: count_return,
          count_return_retail: count_return_retail
        )
    end
  end

  defp user_invoice(user) do
    Ecto.assoc(user, :invoice)
  end

  defp user_invoice_by_id(user, id) do
    user
    |> user_invoice
    |> Repo.get(id)
  end
end
