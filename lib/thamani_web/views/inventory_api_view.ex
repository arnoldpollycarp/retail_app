defmodule ThamaniWeb.InventoryApiView do
  use ThamaniWeb, :view
  alias Thamani.Sales

  def render("index.json", %{inventorys: inventorys}) do
    %{data: render_many(inventorys, ThamaniWeb.InventoryApiView, "inventory.json")}
  end

  def render("show.json", %{inventory: inventory}) do
    %{data: render_one(inventory, ThamaniWeb.InventoryApiView, "inventory.json")}
  end

  def render("inventory.json", %{inventory_api: inventory_api}) do
    %{
      id: inventory_api.id,
      "item id": inventory_api.item,
      "item name": inventory_api.sku.name,
      GTIN: inventory_api.sku.gtin,
      manufacturer: inventory_api.manufacturer,
      mid: inventory_api.mid,
      warehouse: inventory_api.warehouse,
      wid: inventory_api.wid,
      gs1: Float.ceil(Sales.get_gs1_value(), 2),
      discount: inventory_api.discounts.value,
      discount_price:
        String.to_float(inventory_api.price) -
          String.to_float(inventory_api.price) * (inventory_api.discounts.value / 100),
      price:
        Float.ceil(
          String.to_float(inventory_api.price) -
            String.to_float(inventory_api.price) * (inventory_api.discounts.value / 100) +
            Sales.get_gs1_value() + Dispatches.get_price(inventory_api.item), 2
        ),
      category: inventory_api.category,
      quantity: inventory_api.remain,
      active: inventory_api.active,
      retailer: inventory_api.price
    }
  end
end
