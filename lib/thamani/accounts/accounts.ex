defmodule Thamani.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Accounts.User
  use Rummage.Ecto
  alias Thamani.GTIN.Barcode

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get_by!(User, slug: id)

  def get_user(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def verify_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def get_users() do
    Repo.all(from(u in User, select: {u.company, u.id}))
  end

  def get_count_users() do
    Repo.one(from(u in User, select: count(u.id)))
  end

  def check_code(id, code) do
    Repo.one(
      from(u in User, where: u.slug == ^id and u.registercode == ^code, select: count(u.id))
    )
  end

  def check_code_reset(token, code) do
    Repo.one(
      from(u in User, where: u.token == ^token and u.resetcode == ^code, select: count(u.id))
    )
  end

  def get_barcode(current_user) do
    Repo.all(
      from(
        b in Barcode,
        where: b.user_id == ^current_user.id and b.active == ^"true",
        select: {b.code, b.id}
      )
    )
  end

  def get_id(number) do
    Repo.one(
      from(u in User, where: u.account_number == ^number and u.active == ^"true", select: u.id)
    )
  end

  def get_name(number) do
    Repo.one(
      from(
        u in User,
        where: u.account_number == ^number,
        select: fragment("concat('',?,' ',?)", u.firstname, u.lastname)
      )
    )
  end
end
