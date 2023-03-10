defmodule ThamaniWeb.NotesAdminController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Inventories
  alias Thamani.Credit_note
  alias Thamani.Dispatches_Warehouse

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "note" when action in [:create, :update])

  def index(conn, _params) do
    notes = Credit_note.list_note()
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()
    render(conn, "index.html", notes: notes, count_4: count_4, count_5: count_5)
  end

  def show(conn, %{"id" => id}) do
    notes = Credit_note.get_notes!(id)
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()

    render(conn, "show.html", notes: notes, count_4: count_4, count_5: count_5)
  end
end
