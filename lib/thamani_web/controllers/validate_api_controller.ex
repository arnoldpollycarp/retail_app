defmodule ThamaniWeb.ValidateApiController do
  use ThamaniWeb, :controller
  alias ThamaniWeb.ErrorView
  alias Plug.Conn

  alias Thamani.Mpesaapi.Mpesa
  alias Thamani.Repo

  def index(conn, _params) do
    render(conn, "index.json", validate: "validate")
  end

  def create(conn, create_params) do
    # changeset = MpesaElixir.Transaction.reverse("MJT0J514B0", 1, "174379", "12", "TESTING", nil)
    #
    # {:ok, _second, %HTTPotion.Response{status_code: status_code, body: result, headers: headers}} = changeset
    #
    # IO.inspect result
    # IO.inspect headers.hdrs
    # IO.inspect status_code
    #
    # text = %{
    #       "ResultCode" => "0",
    #       "ResultDesc" => "Service processing successful" }
    #
    #  if  status_code == 200 do
    %{
      "Body" => %{
        "stkCallback" => %{
          "CheckoutRequestID" => _checkout,
          "MerchantRequestID" => _merchant,
          "ResultCode" => result_code,
          "ResultDesc" => _result_desc
        }
      }
    } = create_params

    IO.inspect(result_code)

    if result_code == 0 do
      %{
        "Body" => %{
          "stkCallback" => %{
            "CheckoutRequestID" => checkout,
            "MerchantRequestID" => _merchant,
            "ResultCode" => result_code,
            "ResultDesc" => _result_desc,
            "CallbackMetadata" => %{
              "Item" => [
                %{"Name" => "Amount", "Value" => amount},
                %{"Name" => "MpesaReceiptNumber", "Value" => receipt_number},
                %{"Name" => "Balance"},
                %{"Name" => "TransactionDate", "Value" => trans_date},
                %{"Name" => "PhoneNumber", "Value" => phone}
              ]
            }
          }
        }
      } = create_params

      IO.inspect(result_code)
      IO.inspect(amount)
      IO.inspect(receipt_number)
      IO.inspect(phone)

      changeset =
        Mpesa.changeset(%Mpesa{}, %{
          "amount" => amount,
          "receipt" => receipt_number,
          "transactiondate" => trans_date,
          "description" => checkout,
          "phone" => phone
        })

      with {:ok, _mpesa} <- Repo.insert(changeset) do
        conn
        |> Conn.put_status(201)
        |> redirect(to: payment_api_path(conn, :index))
      else
        {:error, %{errors: _errors}} ->
          conn
          |> put_status(422)
          |> render(ErrorView, "422.json", %{errors: "false"})
      end
    else
      conn
      |> redirect(to: payment_api_path(conn, :new))
    end
  end
end
