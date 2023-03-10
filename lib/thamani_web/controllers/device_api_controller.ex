defmodule ThamaniWeb.DeviceApiController do
  use ThamaniWeb, :controller
  alias ThamaniWeb.ErrorView
  alias Plug.Conn

  alias Thamani.Devices
  alias Thamani.Devices.Device

  alias Thamani.Repo

  def index(conn, _params) do
    devices = Devices.list_device()
    render(conn, "index.json", devices: devices)
  end

  def show(conn, %{"imei" => imei}) do
    if device = Devices.get_device_by_imei!(imei) do
      render(conn, "show.json", device: device)
    else
      conn
      |> put_status(404)
      |> render(ErrorView, "404.json", error: "Not found")
    end
  end
end
