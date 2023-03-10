defmodule ThamaniWeb.SmsApiController do
  use ThamaniWeb, :controller
  alias Thamani.Africaistalking.Sms

  plug(:put_layout, "validate.html")

  def index(conn, params) do
    IO.inspect(params)
    render(conn, "index.html")
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"phone" => phone, "message" => message}) do
    HTTPotion.start()
    changeset = Sms.send(phone, message)

    {:ok, _second, %HTTPotion.Response{status_code: status_code, body: result, headers: headers}} =
      changeset

    IO.inspect(result)
    IO.inspect(headers)
    IO.inspect(status_code)

    if status_code == 201 do
      render(conn, "index.html", params: "checkout")
    else
      conn
      |> put_flash(:error, "error")
      |> redirect(to: sms_api_path(conn, :new))
    end
  end
end
