defmodule ThamaniWeb.MpesaController do
  use ThamaniWeb, :controller
  require Ecto.Query
  use Rummage.Phoenix.Controller
  alias Thamani.Mpesaapi

  plug(:put_layout, "dashboard.html")

  def index(conn, _params) do
    mpesa = Mpesaapi.list_mpesa()

    render(conn, "index.html", access_log: "", mpesa: mpesa)
  end
end
