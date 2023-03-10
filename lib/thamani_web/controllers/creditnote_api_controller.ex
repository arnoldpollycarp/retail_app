defmodule ThamaniWeb.CreditnoteApiController do
  use ThamaniWeb, :controller
  alias ThamaniWeb.ErrorView

  alias Thamani.Credit_note

  def index(conn, %{"security_key" => security_key, "user_id" => user_id}) do
    if security_key == Application.get_env(:mpesa_elixir, :keylock) do
      notes = Credit_note.list_notes_by_user(user_id)
      render(conn, "index.json", notes: notes)
    else
      conn
      |> put_status(404)
      |> render(ErrorView, "404.json", error: "Not found")
    end
  end

  def create(conn, %{
        "credit_params" => %{
          "receipt_number" => receipt_number,
          "item_name" => item,
          "quantity" => quantity,
          "customer" => customer,
          "phone" => phone,
          "staff" => staff,
          "description" => description,
          "user_id" => user_id
        }
      }) do
    changeset =
      Credit_note.create_notes(%{
        "note_number" =>
          ("THO" <>
             SecureRandom.urlsafe_base64(8) <> String.slice(to_string(DateTime.utc_now()), 0..9))
          |> String.replace("-", ""),
        "receipt_number" => receipt_number,
        "item" => item,
        "quantity" => quantity,
        "customer" => customer,
        "phone" => phone,
        "staff" => staff,
        "description" => description,
        "active" => "false",
        "user_id" => user_id
      })

    case changeset do
      {:ok, _} ->
        render(conn, ErrorView, "201.json", error: "true")

      {:error, _, changeset, _} ->
        render(conn, ErrorView, "422.json", changeset: changeset, error: "false")
    end
  end

  def show(conn, %{"security_key" => security_key, "user_id" => user_id, "id" => id}) do
    if security_key == Application.get_env(:mpesa_elixir, :keylock) do
      if note = Credit_note.get_note_by_user!(user_id, id) do
        render(conn, "show.json", note: note)
      else
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
      end
    else
      conn
      |> put_status(404)
      |> render(ErrorView, "404.json", error: "Not found")
    end
  end
end
