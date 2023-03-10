defmodule ThamaniWeb.CompanyController do
  use ThamaniWeb, :controller
  require Ecto.Query
  require Ecto
  use Ecto.Schema

  alias Thamani.Companies.Company
  alias Thamani.Accounts.User
  alias Thamani.Repo

  plug(:put_layout, "manufacturer.html")
  plug(:scrub_params, "company" when action in [:create, :update])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, %{"user_id" => user_id}, _current_user) do
    user = User |> Repo.get_by!(slug: user_id)

    company =
      user
      |> user_company
      |> Repo.all()

    render(conn, "index.html", company: company, user: user)
  end

  def new(conn, params, current_user) do
    changeset =
      current_user
      |> Ecto.build_assoc(:companies)
      |> Company.changeset(params)

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"company" => company_params}, current_user) do
    changeset =
      current_user
      |> Ecto.build_assoc(:companies)
      |> Company.changeset(company_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "company created successfully.")
        |> redirect(to: user_company_path(conn, :index, current_user.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}, current_user) do
    user = User |> Repo.get_by!(slug: user_id)

    company =
      user
      |> user_company_by_id(id)

    if company do
      render(conn, "show.html", company: company, user: user)
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: user_company_path(conn, :index, current_user.slug))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    company =
      current_user
      |> user_company_by_id(id)

    if company do
      changeset = Company.changeset(company, %{})
      render(conn, "edit.html", company: company, changeset: changeset)
    else
      conn
      |> put_flash(:error, "Not authorised to access that page")
      |> redirect(to: user_company_path(conn, :index, current_user.slug))
    end
  end

  def update(conn, %{"id" => id, "company" => company_params}, current_user) do
    company =
      current_user
      |> user_company_by_id(id)

    changeset = Company.changeset(company, company_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "company updated successfully.")
        |> redirect(to: user_company_path(conn, :index, current_user.slug))

      {:error, changeset} ->
        render(conn, "edit.html", company: company, changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => id}, current_user) do
    user = User |> Repo.get_by!(slug: user_id)

    company =
      user
      |> user_company_by_id(id)

    if current_user.id == company.user_id do
      Repo.delete!(company)

      conn
      |> put_flash(:info, "company deleted successfully.")
      |> redirect(to: user_company_path(conn, :index, user))
    else
      conn
      |> put_flash(:error, "You can’t delete this company")
      |> redirect(to: user_company_path(conn, :index, user))
    end
  end

  defp user_company(user) do
    Ecto.assoc(user, :companies)
  end

  defp user_company_by_id(user, id) do
    user
    |> user_company
    |> Repo.get(id)
  end
end
