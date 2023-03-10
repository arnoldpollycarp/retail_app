defmodule ThamaniWeb.StaffApiController do
  use ThamaniWeb, :controller
  alias ThamaniWeb.ErrorView
  alias Plug.Conn
  alias Thamani.Staffs
  alias Thamani.Staffs.Staff
  alias Thamani.Repo

  def index(conn, _params) do
    staffs = Staffs.list_staff()
    render(conn, "index.json", staffs: staffs)
  end

  def create(conn, params) do
    changeset = Staff.changeset(%Staff{}, params)

    with {:ok, staff} <- Repo.insert(changeset) do
      conn
      |> Conn.put_status(201)
      |> render("show.json", staff: staff)
    else
      {:error, %{errors: _errors}} ->
        conn
        |> put_status(422)
        |> render(ErrorView, "422.json", %{errors: "false"})
    end
  end

  def show(conn, %{"phone" => phone, "passcode" => passcode}) do
    if staff = Staffs.get_staff_by_login!(phone, passcode) do
      render(conn, "show.json", staff: staff)
    else
      conn
      |> put_status(404)
      |> render(ErrorView, "404.json", error: "Not found")
    end
  end

  def update(conn, %{"id" => id} = params) do
    staff = Repo.get(Staff, id)

    changeset = Staff.changeset(staff, params)

    with {:ok, staff} <- Repo.update(changeset) do
      render(conn, "show.json", data: staff)
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
    end
  end

  def delete(conn, %{"id" => id}) do
    with staff = %Staff{} <- Repo.get(Staff, id) do
      Staffs.delete_staff(staff)

      conn
      |> Conn.put_status(204)
      |> Conn.send_resp(:no_content, "")
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
    end
  end
end
