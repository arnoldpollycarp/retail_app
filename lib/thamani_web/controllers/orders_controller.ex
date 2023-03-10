defmodule ThamaniWeb.OrdersController do
  use ThamaniWeb, :controller

  require Ecto.Query
  require Ecto
  require Ecto.Schema

  plug(:put_layout, "dashboard.html")

  def index(conn, _params) do
    render(
      conn,
      "dashboard.html",
      list_item: [],
      list_city: [],
      id: ["none"],
      company: ["none"],
      delivery: ["none"],
      quantity: "none",
      total: "none",
      used: "none",
      loader_class: " ",
      field_class: "display:none ",
      field_class2: "display:none ",
      loader_class2: " ",
      loader_class3: " ",
      message_class: " ",
      alert_class: " ",
      long_process_button_text: " ",
      category_text: " ",
      item_text: " ",
      uom_text: " ",
      quantity_text: " "
    )
  end
end
