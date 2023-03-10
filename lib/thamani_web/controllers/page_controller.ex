defmodule ThamaniWeb.PageController do
  use ThamaniWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
