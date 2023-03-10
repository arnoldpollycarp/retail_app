defmodule ThamaniWeb.RecievedAdminRetmanController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Dispatches_Retailer

  alias Thamani.Inventories

  plug(:put_layout, "retail.html")

  def index(conn, _params) do
    recieved = Dispatches_Retailer.list_recieved_all()
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Retailer.get_count_recieved_all!()

    render(conn, "index.html", recieved: recieved, count_5: count_5, count_4: count_4)
  end

  def show(conn, %{"id" => id}) do
    recieved = Dispatches_Retailer.get_recieved_all(id)
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Retailer.get_count_recieved_all!()

    render(conn, "show.html", recieved: recieved, count_5: count_5, count_4: count_4)
  end
end
