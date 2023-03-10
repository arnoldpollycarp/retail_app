defmodule ThamaniWeb.CommerceController do
  use ThamaniWeb, :controller
  import Ecto.Query
require Ecto
use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Items
  alias Thamani.Carts.Cart
  alias Thamani.Pmasters
  alias Thamani.Items.Sku
  alias Thamani.Carts
  alias Thamani.Warehouse_orders.Warehouse_order
  alias Thamani.Warehouse_orders
  alias Thamani.Kcitys
  alias Thamani.Repo

  plug(:put_layout, "commerce.html")

  def action(conn, _) do
      apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, params, _current_user) do

    {query, rummage} =
      Sku

      |> Sku.rummage(params["rummage"])

    sku =
      query
      |> where([c], c.active ==^ "true")
      |> preload([i], :pmaster)
      |> preload([i], :user)
      |> Repo.all()


    cat = Pmasters.get_items()
    items = Items.list_sku()

    render(conn, "index.html", items: items, sku: sku, rummage: rummage,cat: cat)

  end

  def show(conn, %{"id" => _id}, current_user) do

    sku = Carts.get_cart_user!(current_user.id)
    IO.inspect sku
    total =
         case Carts.get_cart_total!(current_user.id)  do
         nil -> 0
           _ ->  Carts.get_cart_total!(current_user.id)

       end

      list_city = Kcitys.list_cities()
      changeset = Warehouse_orders.change_warehouse_order(%Warehouse_order{})

    render(conn, "show.html", sku: sku, total: total, changeset: changeset, list_city: list_city)

  end

  def get_timestamp() do
    Timex.local()
    |> Timex.format!("{YYYY}{0M}{0D}{h24}{m}{s}")
  end

    def create(conn, %{"warehouse_order" => %{"city" => city,"description" => description}}, current_user) do

      sku_id = Carts.get_cart_user_id!(current_user.id)
      sku = Carts.get_cart_user_item!(current_user.id)
      qty = Carts.get_cart_user_qty!(current_user.id)
      cat = Carts.get_cart_user_cat!(current_user.id)
      total =
           case Carts.get_cart_total!(current_user.id)  do
           nil -> 0
             _ ->  Carts.get_cart_total!(current_user.id)

         end
      list_city = Kcitys.list_cities()
      code = "tow"<>get_timestamp()<>String.slice(current_user.slug, 1..5)
        list_item =
          sku
          |> Enum.chunk_every(1)
          |> Enum.map(fn [a] -> %{"item" => a} end)

        list_quantity =
          qty
          |> Enum.chunk_every(1)
          |> Enum.map(fn [b] -> %{"quantity" => b} end)

        list_category =
          cat
          |> Enum.chunk_every(1)
          |> Enum.map(fn [c] -> %{"category" => c} end)

        list =
          Enum.map(
            for {x, y, z} <- Enum.zip([list_item, list_quantity, list_category]) do
              Enum.concat([x, y, z])
            end,
            fn x ->
              Enum.into(x, %{"order_id" => code,"city" => city,"warehouse" => 176 ,"description" => description, "active" => "false", "user_id" => current_user.id})
            end
          )

        changesets =
          Enum.map(list, fn breakbulk ->
            Warehouse_order.changeset(%Warehouse_order{}, breakbulk)
          end)

        result =
          changesets
          |> Enum.with_index()
          |> Enum.reduce(Ecto.Multi.new(), fn {changeset, index}, multi ->
            Ecto.Multi.insert(multi, Integer.to_string(index), changeset)
          end)
          |> Repo.transaction()

        case result do
          {:ok, _multi_order_result} ->

            items =
                sku_id
                |> Enum.chunk_every(1)
                |> Enum.map(fn [a] -> Repo.get_by!(Cart, id: a) end)


             changeset = Enum.map(items,fn x -> Ecto.Changeset.change(x, status: "checkout") end)

            update_result =
             changeset
             |> Enum.with_index()
             |> Enum.reduce(Ecto.Multi.new(), fn {changes, index}, multi ->
               Ecto.Multi.update(multi, Integer.to_string(index), changes)
             end)
             |> Repo.transaction()

                          case update_result do
                            {:ok, _} ->
                              conn
                              |> put_flash(:info, "Order created successfully.")
                              |> redirect(to: commerce_path(conn, :index))


                              {:error, %Ecto.Changeset{} = _changeset} ->
                                render(
                                  conn,
                                  "show.html",
                                  changeset: changeset,
                                  sku: sku,
                                  total: total,
                                  list_city: list_city

                                )
                          end


        {:error, %Ecto.Changeset{} = changeset} ->
          render(
            conn,
            "show.html",
            changeset: changeset,
            sku: sku,
            total: total,
            list_city: list_city

          )
      end
    end

    def orders(conn, _params, current_user) do
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


      render(
        conn,
        "orders.html",
        warehouse_order: warehouse_order,
        cat: cat,
        user: user

      )
    end

    def comms(conn, _params, current_user) do
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


      render(
        conn,
        "comms.html",
        warehouse_order: warehouse_order,
        cat: cat,
        user: user

      )
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
