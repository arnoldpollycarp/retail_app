defmodule ThamaniWeb.RetailAdminDashboardCommander do
  use Drab.Commander
  alias Thamani.Sales

  onconnect(:connected)

  def connected(socket) do
    # Sentix is already started within application supervisor

    file_change_loop(socket, Application.get_env(:drab_poc, :watch_file))
  end

  defp file_change_loop(socket, file_path) do
    date = String.slice(to_string(DateTime.utc_now()), 0..9)

    count_2 =
      case Sales.get_count_sales_all() do
        nil -> 0.0
        _ -> Sales.get_count_sales_all()
      end

    count_3 =
      case Sales.get_countall_retailer_value_today(date) do
        nil -> 0.0
        _ -> Float.ceil(Sales.get_countall_retailer_value_today(date), 2)
      end

    socket |> poke(count_3: count_3)
    socket |> poke(count_2: count_2)

    file_change_loop(socket, file_path)
  end
end
