defmodule ThamaniWeb.DeviceAdminController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Inventories
  alias Thamani.Devices
  alias Thamani.Devices.Device
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches
  alias Thamani.Repo

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "device" when action in [:create, :update])

  def index(conn, _params) do
    device = Devices.list_device()
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()

    render(conn, "index.html", device: device, count_4: count_4, count_5: count_5)
  end

  def show(conn, %{"id" => id}) do
    device = Devices.get_device!(id)
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()
    render(conn, "show.html", device: device, count_4: count_4, count_5: count_5)
  end

  def new(conn, params) do
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()
    company = Dispatches.get_company()

    changeset =
      %Device{}
      |> Device.changeset(params)

    render(
      conn,
      "new.html",
      changeset: changeset,
      count_4: count_4,
      count_5: count_5,
      company: company
    )
  end

  def create(conn, %{
        "device" => %{
          "name" => name,
          "imei" => imei,
          "description" => description,
          "user_id" => user_id,
          "active" => active
        }
      }) do
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()
    company = Dispatches.get_company()

    changeset =
      %Device{}
      |> Device.changeset(%{
        "name" => name,
        "imei" => imei,
        "description" => description,
        "active" => active,
        "user_id" => String.to_integer(user_id)
      })

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Device was created successfully")
        |> redirect(to: device_admin_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          count_4: count_4,
          count_5: count_5,
          company: company
        )
    end
  end

  def edit(conn, %{"id" => id}) do
    device = Devices.get_device!(id)
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()
    company = Dispatches.get_company()

    if device do
      changeset = Device.changeset(device, %{})

      render(
        conn,
        "edit.html",
        device: device,
        changeset: changeset,
        count_4: count_4,
        count_5: count_5,
        company: company
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: device_admin_path(conn, :index))
    end
  end

  def update(conn, %{
        "id" => id,
        "device" => %{
          "name" => name,
          "imei" => imei,
          "description" => description,
          "user_id" => user_id,
          "active" => active
        }
      }) do
    device = Devices.get_device!(id)
    count_4 = Inventories.get_count_restock_man_all()
    count_5 = Dispatches_Warehouse.get_count_recieved_all!()
    company = Dispatches.get_company()

    changeset =
      Device.changeset(device, %{
        "name" => name,
        "imei" => imei,
        "description" => description,
        "active" => active,
        "user_id" => String.to_integer(user_id)
      })

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Device was updated successfully")
        |> redirect(to: device_admin_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          device: device,
          changeset: changeset,
          count_4: count_4,
          count_5: count_5,
          company: company
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    device = Devices.get_device!(id)

    Repo.delete!(device)

    conn
    |> put_flash(:info, "Device was deleted successfully")
    |> redirect(to: device_admin_path(conn, :index))
  end
end
