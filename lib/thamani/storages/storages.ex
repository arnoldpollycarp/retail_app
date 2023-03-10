defmodule Thamani.Storages do
  @moduledoc """
  The Storages context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Storages.Storage

  @doc """
  Returns the list of storages.

  ## Examples

      iex> list_storages()
      [%Storage{}, ...]

  """
  def list_storages do
    Storage
    |> Repo.all()
    |> Repo.preload(:dispatch)
    |> Repo.preload(:user)
    |> Repo.preload(:sku)
  end

  @doc """
  Gets a single storage.

  Raises `Ecto.NoResultsError` if the Storage does not exist.

  ## Examples

      iex> get_storage!(123)
      %Storage{}

      iex> get_storage!(456)
      ** (Ecto.NoResultsError)

  """
  def get_storage!(id) do
    Storage
    |> Repo.get!(id)
    |> Repo.preload(:dispatch)
    |> Repo.preload(:user)
    |> Repo.preload(:sku)
  end

  @doc """
  Creates a storage.

  ## Examples

      iex> create_storage(%{field: value})
      {:ok, %Storage{}}

      iex> create_storage(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_storage(attrs \\ %{}) do
    %Storage{}
    |> Storage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a storage.

  ## Examples

      iex> update_storage(storage, %{field: new_value})
      {:ok, %Storage{}}

      iex> update_storage(storage, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_storage(%Storage{} = storage, attrs) do
    storage
    |> Storage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Storage.

  ## Examples

      iex> delete_storage(storage)
      {:ok, %Storage{}}

      iex> delete_storage(storage)
      {:error, %Ecto.Changeset{}}

  """
  def delete_storage(%Storage{} = storage) do
    Repo.delete(storage)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking storage changes.

  ## Examples

      iex> change_storage(storage)
      %Ecto.Changeset{source: %Storage{}}

  """
  def change_storage(%Storage{} = storage) do
    Storage.changeset(storage, %{})
  end
end
