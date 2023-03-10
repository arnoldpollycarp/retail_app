defmodule ThamaniWeb.Gs1DashboardCommander do
  use Drab.Commander
  alias Thamani.Items
  alias Thamani.Sales

  onconnect(:connected)

  def connected(socket) do
    # Sentix is already started within application supervisor

    file_change_loop(socket, Application.get_env(:drab_poc, :watch_file))
  end

  defp file_change_loop(socket, file_path) do
    date = String.slice(to_string(DateTime.utc_now()), 0..9)

    count_2 =
      case Sales.get_countall_manufacturer_value() do
        nil -> 0.0
        _ -> Float.ceil(Sales.get_countall_manufacturer_value(), 2)
      end

    count_3 =
      case Sales.get_countall_warehouse_value() do
        nil -> 0.0
        _ -> Sales.get_countall_warehouse_value()
      end

    count_4 =
      case Sales.get_countall_retailer_value() do
        nil -> 0.0
        _ -> Float.ceil(Sales.get_countall_retailer_value(), 2)
      end

    count_5 =
      case Sales.get_countall_gs1_value() do
        nil -> 0.0
        _ -> Float.ceil(Sales.get_countall_gs1_value(), 2)
      end

    count_6 = Float.ceil(count_2 + count_3 + count_4 + count_5, 2)

    count_7 =
      case Sales.get_countall_manufacturer_value_today(date) do
        nil -> 0
        _ -> Float.ceil(Sales.get_countall_manufacturer_value_today(date), 2)
      end

    count_8 =
      case Sales.get_countall_warehouse_value_today(date) do
        nil -> 0.0
        _ -> Float.ceil(Sales.get_countall_warehouse_value_today(date), 2)
      end

    count_9 =
      case Sales.get_countall_retailer_value_today(date) do
        nil -> 0.0
        _ -> Float.ceil(Sales.get_countall_retailer_value_today(date), 2)
      end

    count_10 =
      case Sales.get_countall_gs1_value_today(date) do
        nil -> 0
        _ -> Float.ceil(Sales.get_countall_gs1_value_today(date), 2)
      end

    count_11 = count_7 + count_8 + count_9 + count_10

    socket |> poke(count_2: count_2)
    socket |> poke(count_3: count_3)
    socket |> poke(count_4: count_4)
    socket |> poke(count_5: count_5)
    socket |> poke(count_6: count_6)
    socket |> poke(count_7: count_7)
    socket |> poke(count_8: count_8)
    socket |> poke(count_9: count_9)
    socket |> poke(count_10: count_10)
    socket |> poke(count_11: count_11)
    file_change_loop(socket, file_path)
  end

  defhandler return_list_sale(socket, sender) do
    date_search = sender.params["date_search"]

    date_search_2 = sender.params["date_search_2"]
    poke(socket, loader_class: "loader-show")

    poke(socket, loader_class: "loader-hide")

    count_12 =
      case Sales.get_countall_manufacturer_value_by_search(date_search, date_search_2) do
        nil ->
          0

        _ ->
          Float.ceil(
            Sales.get_countall_manufacturer_value_by_search(date_search, date_search_2),
            2
          )
      end

    count_13 =
      case Sales.get_countall_warehouse_value_by_search(date_search, date_search_2) do
        nil ->
          0

        _ ->
          Float.ceil(Sales.get_countall_warehouse_value_by_search(date_search, date_search_2), 2)
      end

    count_14 =
      case Sales.get_countall_retailer_value_by_search(date_search, date_search_2) do
        nil ->
          0

        _ ->
          Float.ceil(Sales.get_countall_retailer_value_by_search(date_search, date_search_2), 2)
      end

    count_15 =
      case Sales.get_countall_gs1_value_by_search(date_search, date_search_2) do
        nil -> 0
        _ -> Float.ceil(Sales.get_countall_gs1_value_by_search(date_search, date_search_2), 2)
      end

    count_16 = count_12 + count_13 + count_14 + count_15

    socket |> poke(count_12: count_12)
    socket |> poke(count_13: count_13)
    socket |> poke(count_14: count_14)
    socket |> poke(count_15: count_15)
    socket |> poke(count_16: count_16)
  end


    defhandler return_list_sale_by_retailer(socket, sender) do
      date_search = sender.params["date_search"]

      date_search_2 = sender.params["date_search_2"]

      retailer = sender.params["retailer"]
      poke(socket, loader_class: "loader-show")

      poke(socket, loader_class: "loader-hide")

      count_17 =
        case Sales.get_countall_manufacturer_value_by_search_retailer(date_search, date_search_2, retailer) do
          nil ->
            0

          _ ->
            Float.ceil(
              Sales.get_countall_manufacturer_value_by_search_retailer(date_search, date_search_2, retailer),
              2
            )
        end

      count_18 =
        case Sales.get_countall_warehouse_value_by_search_retailer(date_search, date_search_2, retailer) do
          nil ->
            0

          _ ->
            Float.ceil(Sales.get_countall_warehouse_value_by_search_retailer(date_search, date_search_2, retailer), 2)
        end

      count_19 =
        case Sales.get_countall_retailer_value_by_search_retailer(date_search, date_search_2, retailer) do
          nil ->
            0

          _ ->
            Float.ceil(Sales.get_countall_retailer_value_by_search_retailer(date_search, date_search_2, retailer), 2)
        end

      count_20 =
        case Sales.get_countall_gs1_value_by_search_retailer(date_search, date_search_2, retailer) do
          nil ->
            0
          _ ->
          Float.ceil(Sales.get_countall_gs1_value_by_search_retailer(date_search, date_search_2, retailer), 2)
        end

      count_21 = count_17 + count_18 + count_19 + count_20

      socket |> poke(count_17: count_17)
      socket |> poke(count_18: count_18)
      socket |> poke(count_19: count_19)
      socket |> poke(count_20: count_20)
      socket |> poke(count_21: count_21)
    end
end
