defmodule ThamaniWeb.SaleDashboardCommander do
  use Drab.Commander

  alias Thamani.Dispatches
  alias Thamani.Dispatches_Retailer
  alias Thamani.Dispatches_Warehouse

  alias Thamani.Sales

  onconnect(:connected)

  def connected(socket) do
    # Sentix is already started within application supervisor

    file_change_loop(socket, Application.get_env(:drab_poc, :watch_file))
  end

  defp file_change_loop(socket, file_path) do
    current_user = Drab.Live.peek(socket, :current_user)

    count_0 = Dispatches.get_count_dispatch_value(current_user)
    count_01 = Dispatches_Retailer.get_count_dispatch_value(current_user)
    count_2 = Sales.get_count_manufacturer_value(current_user)
    count_3 = Dispatches_Warehouse.get_count_dispatch_value(current_user)
    count_4 = Sales.get_count_warehouse_value(current_user)
    count_5 = Sales.get_count_sales(current_user)
    count_6 = Sales.get_count_retailer_value(current_user)

    date = String.slice(to_string(DateTime.utc_now()), 0..9)

    count_7 = Sales.get_count_manufacturer_value_today(current_user, date)
    count_8 = Sales.get_count_warehouse_value_today(current_user, date)
    count_9 = Sales.get_count_retailer_value_today(current_user, date)

    #if is_nil(count_0) do
    #  socket |> poke(count_0: 0)
    #  else
    #     socket |> poke(count_0: count_0)
    #    end

   # if is_nil(count_01) do
   #   socket |> poke(count_1: 0)
   # else
   #   socket |> poke(count_1: count_01)
   # end

    if is_nil(count_2) do
      socket |> poke(count_2: 0)
    else
      socket |> poke(count_2: Float.ceil(count_2, 2))
    end

   # socket |> poke(count_3: count_3)

    if is_nil(count_4) do
      socket |> poke(count_4: 0)
    else
      socket |> poke(count_4: Float.ceil(count_4, 2))
    end

    if is_nil(count_5) do
      socket |> poke(count_5: 0)
    else
      socket |> poke(count_5: Dispatches.to_integer(count_5))
    end

    if is_nil(count_6) do
      socket |> poke(count_6: 0)
    else
      socket |> poke(count_6: Float.ceil(count_6, 2))
    end

    if is_nil(count_7) do
      socket |> poke(count_7: 0)
    else
      socket |> poke(count_7: Float.ceil(count_7, 2))
    end

    if is_nil(count_8) do
      socket |> poke(count_8: 0)
    else
      socket |> poke(count_8: Float.ceil(count_8, 2))
    end

    if is_nil(count_9) do
      socket |> poke(count_9: 0)
    else
      socket |> poke(count_9: Float.ceil(count_9, 2))
    end

    file_change_loop(socket, file_path)
  end

  defhandler return_list_sale(socket, sender) do
    date_search = sender.params["date_search"]

    date_search_2 = sender.params["date_search_2"]
    current_user = Drab.Live.peek(socket, :current_user)

    count_10 =
      case Sales.get_count_manufacturer_value_by_search(current_user, date_search, date_search_2) do
        nil ->
          0.0

        _ ->
          Float.ceil(
            Sales.get_count_manufacturer_value_by_search(
              current_user,
              date_search,
              date_search_2
            ),
            2
          )
      end

    count_11 =
      case Sales.get_count_warehouse_value_by_search(current_user, date_search, date_search_2) do
        nil ->
          0.0

        _ ->
          Float.ceil(
            Sales.get_count_warehouse_value_by_search(current_user, date_search, date_search_2),
            2
          )
      end

    count_12 =
      case Sales.get_count_retailer_value_by_search(current_user, date_search, date_search_2) do
        nil ->
          0.0

        _ ->
          Float.ceil(
            Sales.get_count_retailer_value_by_search(current_user, date_search, date_search_2),
            2
          )
      end

    poke(socket, loader_class: "loader-show")

    poke(socket, loader_class: "loader-hide")

    socket |> poke(count_10: count_10)
    socket |> poke(count_11: count_11)
    socket |> poke(count_12: count_12)
  end

  defhandler return_list_sale_by_retailer(socket, sender) do
    date_search = sender.params["date_search"]

    date_search_2 = sender.params["date_search_2"]

    retailer = sender.params["retailer"]
    current_user = Drab.Live.peek(socket, :current_user)

    count_13 =
      case Sales.get_count_manufacturer_value_by_search_retailer(current_user, date_search, date_search_2, retailer) do
        nil ->
          0.0

        _ ->
          Float.ceil(
            Sales.get_count_manufacturer_value_by_search_retailer(current_user, date_search, date_search_2, retailer),  2)
      end

    count_14 =
      case Sales.get_count_warehouse_value_by_search_retailer(current_user, date_search, date_search_2, retailer) do
        nil ->
          0.0

        _ ->
          Float.ceil(
            Sales.get_count_warehouse_value_by_search_retailer(current_user, date_search, date_search_2, retailer),
            2
          )
      end

    count_15 =
      case Sales.get_count_retailer_value_by_search_retailer(current_user, date_search, date_search_2, retailer) do
        nil ->
          0.0

        _ ->
          Float.ceil(
            Sales.get_count_retailer_value_by_search_retailer(current_user, date_search, date_search_2, retailer),
            2
          )
      end

    poke(socket, loader_class: "loader-show")

    poke(socket, loader_class: "loader-hide")

    socket |> poke(count_13: count_13)
    socket |> poke(count_14: count_14)
    socket |> poke(count_15: count_15)
  end
end
