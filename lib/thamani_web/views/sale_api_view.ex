defmodule ThamaniWeb.SaleApiView do
  use ThamaniWeb, :view

  def render("index.json", %{sales: sales}) do
    %{data: render_many(sales, ThamaniWeb.SaleApiView, "sale.json"), error: true}
  end

  def render("show.json", %{sale: sale}) do
    %{data: render_one(sale, ThamaniWeb.SaleApiView, "sale.json")}
  end

  def render("sale.json", %{sale_api: sale_api}) do
    %{
      uuid: sale_api.id,
      item: sale_api.item,
      price: sale_api.retailer,
      mode: sale_api.mode,
      "quantity sold": sale_api.quantity
    }
  end
end
