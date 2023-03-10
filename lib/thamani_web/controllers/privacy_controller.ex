defmodule ThamaniWeb.PrivacyController do
  use ThamaniWeb, :controller

  plug(:put_layout, "privacy.html")

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
