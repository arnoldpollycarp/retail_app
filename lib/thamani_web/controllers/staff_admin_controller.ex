defmodule ThamaniWeb.StaffAdminController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Inventories
  alias Thamani.Staffs
  alias Thamani.Dispatches_Warehouse

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "staff" when action in [:create, :update])

  def index(conn, _params) do
    staff = Staffs.list_staff()
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()

    render(conn, "index.html", staff: staff, count_4: count_4, count_5: count_5)
  end

  def show(conn, %{"id" => id}) do
    staff = Staffs.get_staff!(id)
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()
    render(conn, "show.html", staff: staff, count_4: count_4, count_5: count_5)
  end
end
