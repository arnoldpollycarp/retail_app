defmodule ThamaniWeb.WarehouseAdminDashboardCommander do
  use Drab.Commander
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Sales

  onconnect(:connected)

  def connected(socket) do
    # Sentix is already started within application supervisor

    file_change_loop(socket, Application.get_env(:drab_poc, :watch_file))
  end

  defp file_change_loop(socket, file_path) do
    # current_user = Drab.Live.peek(socket, :current_user)

    date = String.slice(to_string(DateTime.utc_now()), 0..9)

    count_2 =
      case Dispatches_Warehouse.get_count_dispatch_value_all() do
        nil -> 0
        _ -> Dispatches_Warehouse.get_count_dispatch_value_all()
      end

    count_6 =
      case Sales.get_countall_warehouse_value_today(date) do
        nil -> 0.0
        _ -> Float.ceil(Sales.get_countall_warehouse_value_today(date), 2)
      end

    count_7 =
      case Sales.get_countall_warehouse_value() do
        nil -> 0.0
        _ -> Sales.get_countall_warehouse_value()
      end

    count_8 = count_2 - count_7
    socket |> poke(count_6: count_6)
    socket |> poke(count_2: count_8)

    file_change_loop(socket, file_path)
  end
end
