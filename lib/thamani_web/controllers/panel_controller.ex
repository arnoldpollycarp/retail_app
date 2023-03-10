defmodule ThamaniWeb.PanelController do
  use ThamaniWeb, :controller

  plug(:put_layout, "panel.html")

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
