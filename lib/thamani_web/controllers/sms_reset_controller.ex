defmodule ThamaniWeb.SmsResetController do
  use ThamaniWeb, :controller
  alias Thamani.Mailer
  alias Thamani.Accounts
  alias Thamani.Africaistalking.Sms

  plug(:put_layout, "validate.html")

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, params) do
    IO.inspect(params)
    render(conn, "index.html")
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def send_email_notification(email, code) do
    Mailer.reset_email(email, code)
  end

  def create(conn, %{"type" => type}, current_user) do
    HTTPotion.start()
    count = Accounts.get_count_users()

    code =
      (SecureRandom.uuid() |> String.replace("-", "") |> String.slice(0..6)) <>
        to_string(count + 1)

    message = "Your Thamani online reset code is #{code} "
    token = SecureRandom.urlsafe_base64()

    if type == "phone" do
      changeset = Sms.reset(current_user.phone, message)
      Accounts.update_user(current_user, %{"resetcode" => code, "token" => token})

      {:ok, _second,
       %HTTPotion.Response{status_code: status_code, body: result, headers: headers}} = changeset

      IO.inspect(result)
      IO.inspect(headers)
      IO.inspect(status_code)

      if status_code == 201 do
        conn
        |> put_flash(:info, "Kindly place the reset code sent to your email.")
        |> redirect(to: reset_path(conn, :edit, token))
      else
        conn
        |> put_flash(:error, "error")
        |> redirect(to: user_path(conn, :show, current_user.id))
      end
    else
      cond do
        current_user && current_user.active == "true" ->
          {:ok, current_user}
          Accounts.update_user(current_user, %{"resetcode" => code, "token" => token})
          send_email_notification(current_user.email, code)

          conn
          |> put_flash(:info, "Kindly place the reset code sent to your email.")
          |> redirect(to: reset_path(conn, :edit, token))

        true ->
          {:error, :unauthorized}

          conn
          |> put_flash(:error, "The email does not exist")
          |> redirect(to: reset_path(conn, :new))
      end
    end
  end
end
