defmodule ThamaniWeb.RetailAdminReturnController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Retail_Returns
  alias Thamani.Inventories
  alias Thamani.Dispatches_Warehouse

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "retail__return" when action in [:create, :update])

  def index(conn, _params) do
    retail_return = Retail_Returns.list_retail_returns()
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()

    render(conn, "index.html", retail_return: retail_return, count_4: count_4, count_5: count_5)
  end

  def show(conn, %{"id" => id}) do
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()
    retail_return = Retail_Returns.get_retail_return!(id)

    render(conn, "show.html", retail_return: retail_return, count_4: count_4, count_5: count_5)
  end
end
