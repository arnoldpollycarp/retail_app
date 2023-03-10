defmodule ThamaniWeb.PaymentApiController do
  use ThamaniWeb, :controller
  alias ThamaniWeb.ErrorView
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  alias Thamani.Inventories.Inventory
  alias Thamani.Repo

  plug(:put_layout, "validate.html")

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, params, _current_user) do
    IO.inspect(params)
    render(conn, "index.html", params: params)
  end

  def new(conn, _params, _current_user) do
    render(conn, "new.html")
  end

  def create(conn, %{"phone" => phone}, _current_user) do
    HTTPotion.start()
    # MpesaElixir.C2b.register_callbacks()
    # url = "https://thamanionline.com/callbacks/balance"

    # changeset = MpesaElixir.B2c.payment_request("thamani", 906987, "BusinessPayment", 1,phone,"b2c", nil)
    # changeset = MpesaElixir.C2b.register_callbacks(906987)
    # changeset =   MpesaElixir.C2b.simulate(906987,phone,1,"")
    # changeset = MpesaElixir.Transaction.balance(phone, 4, "none")
    # changeset = MpesaElixir.Account.balance(phone, 4, "none")
    changeset = MpesaElixir.Transaction.status(906987,phone, 4, "STATUS","none")
    #  changeset =  MpesaElixir.StkPush.processrequest(903491,phone, "1dec27e6181f749605247b1f3a9dea0711d8c1787a1414e513704abb968efffd", 1,"ThamaniPay","sales")

    # changeset =
    #   MpesaElixir.StkPush.processrequest(
    #     903_491,
    #     phone,
    #     "1dec27e6181f749605247b1f3a9dea0711d8c1787a1414e513704abb968efffd",
    #     1,
    #     "ThamaniPay",
    #     "sales"
    #   )

    {:ok, _second, %HTTPotion.Response{status_code: status_code, body: body, headers: headers}} =
      changeset

    IO.inspect(body)
    IO.inspect(headers.hdrs)
    IO.inspect(status_code)

    if status_code == 200 do
      render(conn, "index.html", params: "checkout")
    else
      conn
      |> put_flash(:error, "error")
      |> redirect(to: payment_api_path(conn, :new))
    end
  end

  def update(conn, %{"id" => id} = params, _current_user) do
    inventories = Repo.get(Inventory, id)
    changeset = Inventory.changeset(inventories, params)

    with {:ok, payment} <- Repo.update(changeset) do
      render(conn, "show.json", data: payment)
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
    end
  end
end
