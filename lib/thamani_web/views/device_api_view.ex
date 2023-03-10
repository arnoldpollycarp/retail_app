defmodule ThamaniWeb.DeviceApiView do
  use ThamaniWeb, :view

  def render("index.json", %{devices: devices}) do
    %{data: render_many(devices, ThamaniWeb.DeviceApiView, "device.json")}
  end

  def render("show.json", %{device: device}) do
    %{data: render_one(device, ThamaniWeb.DeviceApiView, "device.json")}
  end

  def render("device.json", %{device_api: device_api}) do
    %{
      id: device_api.id,
      name: device_api.name,
      imei: device_api.imei,
      description: device_api.description,
      active: device_api.active,
      user_id: device_api.user_id,
      shop: device_api.user.company
    }
  end
end
