defmodule ThamaniWeb.ManufacturerDashboardCommander do
  use Drab.Commander
  alias Thamani.Dispatches
  alias Thamani.Dispatches_Retailer
  alias Thamani.Sales

  onconnect(:connected)

  def connected(socket) do
    # Sentix is already started within application supervisor

    file_change_loop(socket, Application.get_env(:drab_poc, :watch_file))
  end

  defp file_change_loop(socket, file_path) do
    current_user = Drab.Live.peek(socket, :current_user)

    date = String.slice(to_string(DateTime.utc_now()), 0..9)

    count_0 =
      case Dispatches.get_count_dispatch_value(current_user) do
        nil -> 0
        _ -> Float.ceil(Dispatches.get_count_dispatch_value(current_user), 2)
      end

    count_6 =
      case Sales.get_count_manufacturer_value_today(current_user, date) do
        nil -> 0
        _ -> Float.ceil(Sales.get_count_manufacturer_value_today(current_user, date), 2)
      end

    count_7 =
      case Sales.get_count_manufacturer_value(current_user) do
        nil -> 0
        _ -> Float.ceil(Sales.get_count_manufacturer_value(current_user), 2)
      end

    count_01 =
      case Dispatches_Retailer.get_count_dispatch_value(current_user) do
        nil -> 0
        _ -> Dispatches_Retailer.get_count_dispatch_value(current_user)
      end

    count_2 = count_0 + count_01 - count_7

    socket |> poke(count_6: count_6, count_2: count_2)

    file_change_loop(socket, file_path)
  end
end
