defmodule ThamaniWeb.DeviceController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Inventories
  alias Thamani.Devices.Device
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches_Retailer
  alias Thamani.Repo

  plug(:put_layout, "retail.html")
  plug(:scrub_params, "device" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    if current_user.id == user.id do
      device =
        user
        |> user_code
        |> Repo.all()

      count_4 = Inventories.get_count_restock(current_user)
      count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
      count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

      render(
        conn,
        "index.html",
        device: device,
        user: user,
        count_4: count_4,
        count_5: count_5,
        count_6: count_6
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: device_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    user = current_user
    count_4 = Inventories.get_count_restock(current_user)
    count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
    count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)

    device =
      user
      |> user_code_by_id(id)

    render(
      conn,
      "show.html",
      device: device,
      user: user,
      count_4: count_4,
      count_5: count_5,
      count_6: count_6
    )
  end

  #
  # def new(conn, params, current_user) do
  #   count_4 = Inventories.get_count_restock(current_user)
  #   count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
  #   count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)
  #
  #   changeset =
  #     current_user
  #     |> Ecto.build_assoc(:device)
  #     |> Device.changeset(params)
  #
  #   render(
  #     conn,
  #     "new.html",
  #     changeset: changeset,
  #     count_4: count_4,
  #     count_5: count_5,
  #     count_6: count_6
  #   )
  # end
  #
  # def create(conn, %{"device" => device_params}, current_user) do
  #   count_4 = Inventories.get_count_restock(current_user)
  #   count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
  #   count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)
  #
  #   changeset =
  #     current_user
  #     |> Ecto.build_assoc(:device)
  #     |> Device.changeset(device_params)
  #
  #   case Repo.insert(changeset) do
  #     {:ok, _} ->
  #       conn
  #       |> put_flash(:info, "Device was created successfully")
  #       |> redirect(to: device_path(conn, :index))
  #
  #     {:error, changeset} ->
  #       render(
  #         conn,
  #         "new.html",
  #         changeset: changeset,
  #         count_4: count_4,
  #         count_5: count_5,
  #         count_6: count_6
  #       )
  #   end
  # end
  #
  # def edit(conn, %{"id" => id}, current_user) do
  #   device =
  #     current_user
  #     |> user_code_by_id(id)
  #
  #   count_4 = Inventories.get_count_restock(current_user)
  #   count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
  #   count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)
  #
  #   if device do
  #     changeset = Device.changeset(device, %{})
  #
  #     render(
  #       conn,
  #       "edit.html",
  #       device: device,
  #       changeset: changeset,
  #       count_4: count_4,
  #       count_5: count_5,
  #       count_6: count_6
  #     )
  #   else
  #     conn
  #     |> put_flash(:error, "Not authorised to access that page")
  #     |> redirect(to: device_path(conn, :index))
  #   end
  # end
  #
  # def update(conn, %{"id" => id, "device" => code_params}, current_user) do
  #   device = current_user |> user_code_by_id(id)
  #   count_4 = Inventories.get_count_restock(current_user)
  #   count_5 = Dispatches_Warehouse.get_count_recieved!(current_user.id)
  #   count_6 = Dispatches_Retailer.get_count_recieved!(current_user.id)
  #   changeset = Device.changeset(device, code_params)
  #
  #   case Repo.update(changeset) do
  #     {:ok, _} ->
  #       conn
  #       |> put_flash(:info, "Device was updated successfully")
  #       |> redirect(to: device_path(conn, :index))
  #
  #     {:error, changeset} ->
  #       render(
  #         conn,
  #         "edit.html",
  #         device: device,
  #         changeset: changeset,
  #         count_4: count_4,
  #         count_5: count_5,
  #         count_6: count_6
  #       )
  #   end
  # end
  #
  # def delete(conn, %{ "id" => id}, current_user) do
  #   user = current_user
  #   device = user |> user_code_by_id(id)
  #
  #   if current_user.id == device.user_id || current_user.userlevel do
  #     Repo.delete!(device)
  #
  #     conn
  #     |> put_flash(:info, "Device was deleted successfully")
  #     |> redirect(to: device_path(conn, :index))
  #   else
  #     conn
  #     |> put_flash(:error, "You can’t delete this device")
  #     |> redirect(to: device_path(conn, :index))
  #   end
  # end

  defp user_code(user) do
    Ecto.assoc(user, :device)
  end

  defp user_code_by_id(user, id) do
    user
    |> user_code
    |> Repo.get(id)
  end
end
