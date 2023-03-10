defmodule ThamaniWeb.BalanceApiController do
  use ThamaniWeb, :controller
  alias ThamaniWeb.ErrorView
  alias Plug.Conn

  alias Thamani.Sales
  alias Thamani.Dispatches_Warehouse
  alias Thamani.Dispatches
  alias Thamani.Inventories
  alias Thamani.Inventories.Inventory
  alias Thamani.Accounts.User
  alias Thamani.Mpesaapi.Mpesa
  alias Thamani.Repo
  plug(ThamaniWeb.CurrentUser)

  def index(conn, params) do
    with validate = {"one", "two"} do
      render(conn, "index.json", validate: "validate")
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
    end
  end

  def create(conn, float_params) do
    %{
      "Result" => %{
        "ConversationID" => c_id,
        "OriginatorConversationID" => _original,
        "ReferenceData" => %{"ReferenceItem" => %{"Key" => "QueueTimeoutURL", "Value" => _url}},
        "ResultCode" => result_code,
        "ResultDesc" => result_desc,
        "ResultParameters" => %{
          "ResultParameter" => [
            %{"Key" => "AccountBalance", "Value" => values},
            %{"Key" => "BOCompletedTime", "Value" => _time}
          ]
        },
        "ResultType" => type,
        "TransactionID" => _transc_id
      }
    } = float_params

    IO.inspect(Enum.at(String.split(values, ~r{&}), 1))
    IO.inspect(Enum.at(String.split(Enum.at(String.split(values, ~r{&}), 0), "|"), 3))
    current_user = Guardian.Plug.current_resource(conn)

    with result_code == 0 do
      conn
      |> Conn.put_status(201)
      |> redirect(
        to: float_dashboard_path(conn, :index),
        params: Enum.at(String.split(Enum.at(String.split(values, ~r{&}), 0), "|"), 3)
      )
    else
      {:error, %{errors: errors}} ->
        conn
        |> put_status(422)
        |> render(ErrorView, "422.json", %{errors: "false"})
    end
  end
end
