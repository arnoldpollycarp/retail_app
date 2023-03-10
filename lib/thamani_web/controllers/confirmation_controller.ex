defmodule ThamaniWeb.ConfirmationController do
  use ThamaniWeb, :controller

  plug(:put_layout, "lrp.html")

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end
end
