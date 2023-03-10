defmodule ThamaniWeb.MpesaApiController do
  use ThamaniWeb, :controller
  alias ThamaniWeb.ErrorView

  alias Thamani.Mpesaapi

  def index(conn, params) do
    IO.inspect(params)
    check = Mpesaapi.check_record(params)
    IO.inspect(check)

    if check == 0 do
      conn
      |> put_flash(:error, "The transaction has not been effected")

      render(conn, "index.json", params: params)
    else
      conn
      |> put_flash(:success, "The payment has gone through")

      render(conn, "index.json", params: params)
    end
  end

  def show(conn, %{"params" => params}) do
    check = Mpesaapi.check_record(params)

    if check == 0 do
      render(conn, "show.json", error: false)
    else
      render(conn, "show.json", error: true)
    end
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"phone" => phone, "amount" => amount}) do
    HTTPotion.start()
    MpesaElixir.C2b.register_callbacks()
    value = Kernel.trunc(String.to_float(amount))

    changeset =
      MpesaElixir.StkPush.processrequest(
        903_491,
        phone,
        "1dec27e6181f749605247b1f3a9dea0711d8c1787a1414e513704abb968efffd",
        value,
        "ThamaniPay",
        "sales"
      )

    {:ok, _second, %HTTPotion.Response{status_code: status_code, body: body, headers: headers}} =
      changeset

    %{
      "CheckoutRequestID" => checkout,
      "CustomerMessage" => _message,
      "MerchantRequestID" => _merchant,
      "ResponseCode" => _code,
      "ResponseDescription" => _desc
    } = body

    IO.inspect(body)
    IO.inspect(headers.hdrs)
    IO.inspect(status_code)

    if status_code == 200 do
      conn
      |> put_status(201)
      |> render("index.json", params: checkout)
    else
      conn
      |> put_status(422)
      |> render(ErrorView, "422.json", %{errors: "false"})
    end
  end
end
