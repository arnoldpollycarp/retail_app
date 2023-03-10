defmodule Thamani.Staffs do
  @moduledoc """
  The Staffs context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Staffs.Staff

  @doc """
  Returns the list of staff.

  ## Examples

      iex> list_staff()
      [%Staff{}, ...]

  """
  def list_staff do
    Repo.all(Staff)
    |> Repo.preload(:user)
    |> Repo.preload(:shops)
  end

  @doc """
  Gets a single staff.

  Raises `Ecto.NoResultsError` if the Staff does not exist.

  ## Examples

      iex> get_staff!(123)
      %Staff{}

      iex> get_staff!(456)
      ** (Ecto.NoResultsError)

  """
  def get_staff!(id) do
    Repo.get!(Staff, id)
    |> Repo.preload(:user)
    |> Repo.preload(:shops)
  end

  ## login staff api

  def get_staff_by_login(phone, passcode) do
    Repo.all(from(d in Staff, where: d.phone == ^phone and d.passcode == ^passcode, limit: 1))
    |> Repo.preload(:user)
    |> Repo.preload(:shops)
  end

  def get_staff_by_login!(phone, passcode) do
    Repo.one(from(d in Staff, where: d.phone == ^phone and d.passcode == ^passcode, limit: 1))
    |> Repo.preload(:user)
    |> Repo.preload(:shops)
  end

  @doc """
  Creates a staff.

  ## Examples

      iex> create_staff(%{field: value})
      {:ok, %Staff{}}

      iex> create_staff(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_staff(attrs \\ %{}) do
    %Staff{}
    |> Staff.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a staff.

  ## Examples

      iex> update_staff(staff, %{field: new_value})
      {:ok, %Staff{}}

      iex> update_staff(staff, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_staff(%Staff{} = staff, attrs) do
    staff
    |> Staff.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Staff.

  ## Examples

      iex> delete_staff(staff)
      {:ok, %Staff{}}

      iex> delete_staff(staff)
      {:error, %Ecto.Changeset{}}

  """
  def delete_staff(%Staff{} = staff) do
    Repo.delete(staff)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking staff changes.

  ## Examples

      iex> change_staff(staff)
      %Ecto.Changeset{source: %Staff{}}

  """
  def change_staff(%Staff{} = staff) do
    Staff.changeset(staff, %{})
  end
end
