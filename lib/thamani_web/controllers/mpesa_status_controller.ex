defmodule ThamaniWeb.MpesaStatusController do
  use ThamaniWeb, :controller
  alias ThamaniWeb.ErrorView
  alias Plug.Conn

  alias Thamani.Mpesaapi.Mpesa
  alias Thamani.Repo

  def index(conn, _params) do
    render(conn, "index.json", validate: "validate")
  end

  def create(conn, status_params) do

    %{"Result" =>
   %{"ConversationID" => conv_id, "OriginatorConversationID" => oconv_id,
    "ReferenceData" => %{"ReferenceItem" => %{"Key" => "Occasion", "Value" => valueE}},
    "ResultCode" => result_code,
    "ResultDesc" => "The service request is processed successfully.",
    "ResultParameters" =>
     %{"ResultParameter" =>
       [%{"Key" => "DebitPartyName", "Value" => valueA},
         %{"Key" => "CreditPartyName", "Value" => valueB},
         _OriginatorConversationID,
         %{"Key" => "InitiatedTime", "Value" => itime},
         _CreditPartyCharges,
         %{"Key" => "DebitAccountType", "Value" => _debitacc},
         %{"Key" => "TransactionReason"},
         %{"Key" => "ReasonType", "Value" => _reason},
         %{"Key" => "TransactionStatus", "Value" => _status},
         %{"Key" => "FinalisedTime", "Value" => ftime},
         %{"Key" => "Amount", "Value" => amount},
         _ConversationID,
         %{"Key" => "ReceiptNo", "Value" => receipt_number}
       ]
     }, "ResultType" => 0, "TransactionID" => trans_id
   }
   } = status_params



    IO.inspect(result_code)

    if result_code == 0 do


      IO.inspect(valueA)
      IO.inspect(valueB)
      IO.inspect(amount)
      IO.inspect(receipt_number)
      conn
      |> redirect(to: payment_api_path(conn, :index),  params: "checkout")

    else
      conn
      |> redirect(to: payment_api_path(conn, :new))
    end

  end

  %{"Result" =>
  %{"ConversationID" => "AG_20210607_00005288e031dd038f63",
  "OriginatorConversationID" => "7770-26956952-1",
  "ReferenceData" =>
  %{"ReferenceItem" =>
  %{"Key" => "Occasion", "Value" => "none"}},
   "ResultCode" => 0,
   "ResultDesc" => "The service request is processed successfully.",
   "ResultParameters" =>
   %{"ResultParameter" =>
   [%{"Key" => "DebitPartyName", "Value" => "254700474858 - AWUOCHE ROBERT ALVIN"},
    %{"Key" => "CreditPartyName", "Value" => "906987 - GTS EA LIMITED"},
    %{"Key" => "OriginatorConversationID", "Value" => "22238-17123256-1"},
    %{"Key" => "InitiatedTime", "Value" => 20210508135205},
    %{"Key" => "CreditPartyCharges"}, %{"Key" => "DebitAccountType", "Value" => "MMF Account For Customer"}, %{"Key" => "TransactionReason"}, %{"Key" => "ReasonType", "Value" => "Pay Merchant with OD online"}, %{"Key" => "TransactionStatus", "Value" => "Completed"}, %{"Key" => "FinalisedTime", "Value" => 20210508135205}, %{"Key" => "Amount", "Value" => 1.0}, %{"Key" => "ConversationID", "Value" => "AG_20210508_0000727bdcee3bad082b"}, %{"Key" => "ReceiptNo", "Value" => "PE85PM9COX"}]}, "ResultType" => 0, "TransactionID" => "PF70000000"}}


end
