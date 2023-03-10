defmodule ThamaniWeb.FloatController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema
  use Rummage.Phoenix.Controller
  alias Thamani.Accounts.User
  alias Thamani.Floats
  alias Thamani.Floats.Float
  alias Thamani.Repo

  plug(:put_layout, "float.html")
  plug(:scrub_params, "float" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    user = current_user

    float =
      user
      |> user_code
      |> Repo.all()

    count_debit = Floats.get_debit(current_user)
    count_credit = Floats.get_credit(current_user)
    list_debit = Floats.list_5_debit(current_user)
    list_credit = Floats.list_5_credit(current_user)

    render(
      conn,
      "index.html",
      float: float,
      user: user,
      count_debit: count_debit,
      count_credit: count_credit,
      list_debit: list_debit,
      list_credit: list_credit
    )
  end

  def show(conn, %{"user_id" => user_id, "id" => id}, current_user) do
    user = User |> Repo.get_by!(slug: user_id)
    count_debit = Floats.get_debit(current_user)
    count_credit = Floats.get_credit(current_user)
    list_debit = Floats.list_5_debit(current_user)
    list_credit = Floats.list_5_credit(current_user)

    float =
      user
      |> user_code_by_id(id)

    render(
      conn,
      "show.html",
      float: float,
      user: user,
      count_debit: count_debit,
      count_credit: count_credit,
      list_debit: list_debit,
      list_credit: list_credit
    )
  end

  def new(conn, params, current_user) do
    count_debit = Floats.get_debit(current_user)
    count_credit = Floats.get_credit(current_user)
    list_debit = Floats.list_5_debit(current_user)
    list_credit = Floats.list_5_credit(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:floats)
      |> Float.changeset(params)

    render(
      conn,
      "new.html",
      changeset: changeset,
      count_debit: count_debit,
      count_credit: count_credit,
      list_debit: list_debit,
      list_credit: list_credit
    )
  end

  def create(conn, float_params, current_user) do
    %{"Result" => %{"ResultCode" => result_code, "ResultDesc" => result_desc}} = float_params

    IO.inspect(result_code)
    IO.inspect(result_desc)

    count_debit = Floats.get_debit(current_user)
    count_credit = Floats.get_credit(current_user)
    list_debit = Floats.list_5_debit(current_user)
    list_credit = Floats.list_5_credit(current_user)

    changeset =
      current_user
      |> Ecto.build_assoc(:floats)
      |> Float.changeset(float_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Floats was created successfully")
        |> redirect(to: float_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          count_debit: count_debit,
          count_credit: count_credit,
          list_debit: list_debit,
          list_credit: list_credit
        )
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    float =
      current_user
      |> user_code_by_id(id)

    count_debit = Floats.get_debit(current_user)
    count_credit = Floats.get_credit(current_user)
    list_debit = Floats.list_5_debit(current_user)
    list_credit = Floats.list_5_credit(current_user)

    if float do
      changeset = Float.changeset(float, %{})

      render(
        conn,
        "edit.html",
        float: float,
        changeset: changeset,
        count_debit: count_debit,
        count_credit: count_credit,
        list_debit: list_debit,
        list_credit: list_credit
      )
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: float_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "float" => code_params}, current_user) do
    float = current_user |> user_code_by_id(id)
    count_debit = Floats.get_debit(current_user)
    count_credit = Floats.get_credit(current_user)
    list_debit = Floats.list_5_debit(current_user)
    list_credit = Floats.list_5_credit(current_user)

    changeset = Float.changeset(float, code_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Floats was updated successfully")
        |> redirect(to: float_path(conn, :index))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          float: float,
          changeset: changeset,
          count_debit: count_debit,
          count_credit: count_credit,
          list_debit: list_debit,
          list_credit: list_credit
        )
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => id}, current_user) do
    user = User |> Repo.get_by!(slug: user_id)
    float = user |> user_code_by_id(id)

    if current_user.id == float.user_id || current_user.userlevel do
      Repo.delete!(float)

      conn
      |> put_flash(:info, "Floats was deleted successfully")
      |> redirect(to: float_path(conn, :index))
    else
      conn
      |> put_flash(:error, "You can’t delete this float")
      |> redirect(to: float_path(conn, :index))
    end
  end

  defp user_code(user) do
    Ecto.assoc(user, :floats)
  end

  defp user_code_by_id(user, id) do
    user
    |> user_code
    |> Repo.get(id)
  end
end
