defmodule ThamaniWeb.SaleAdminController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Inventories
  alias Thamani.Sales
  alias Thamani.Sales.Sale
  alias Thamani.Accounts.User
  alias Thamani.Repo

  alias Thamani.Dispatches_Warehouse

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "sale" when action in [:create, :update])

  def index(conn, params) do

    {query, rummage} =
      Sale
      |> Sale.rummage(params["rummage"])

    sale =
      query
      |> Repo.all()
      |> Repo.preload(:sku)
      |> Repo.preload(:user)

    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()

    render(conn, "index.html", sale: sale, rummage: rummage, count_4: count_4, count_5: count_5)
  end

  def show(conn, %{"id" => id}) do
    sale = Sales.get_sale!(id)

    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()

    render(conn, "show.html", sale: sale, count_4: count_4, count_5: count_5)
  end
end
