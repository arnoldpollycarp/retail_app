defmodule Thamani.Pmasters do
  @moduledoc """
  The Pmasters context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Pmasters.Pmaster

  @doc """
  Returns the list of pmaster.

  ## Examples

      iex> list_pmaster()
      [%Pmaster{}, ...]

  """
  def list_pmaster do
    Repo.all(Pmaster)
  end

  @doc """
  Gets a single pmaster.

  Raises `Ecto.NoResultsError` if the Pmaster does not exist.

  ## Examples

      iex> get_pmaster!(123)
      %Pmaster{}

      iex> get_pmaster!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pmaster!(id), do: Repo.get!(Pmaster, id)

  @doc """
  Creates a pmaster.

  ## Examples

      iex> create_pmaster(%{field: value})
      {:ok, %Pmaster{}}

      iex> create_pmaster(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pmaster(attrs \\ %{}) do
    %Pmaster{}
    |> Pmaster.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pmaster.

  ## Examples

      iex> update_pmaster(pmaster, %{field: new_value})
      {:ok, %Pmaster{}}

      iex> update_pmaster(pmaster, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pmaster(%Pmaster{} = pmaster, attrs) do
    pmaster
    |> Pmaster.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Pmaster.

  ## Examples

      iex> delete_pmaster(pmaster)
      {:ok, %Pmaster{}}

      iex> delete_pmaster(pmaster)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pmaster(%Pmaster{} = pmaster) do
    Repo.delete(pmaster)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pmaster changes.

  ## Examples

      iex> change_pmaster(pmaster)
      %Ecto.Changeset{source: %Pmaster{}}

  """
  def change_pmaster(%Pmaster{} = pmaster) do
    Pmaster.changeset(pmaster, %{})
  end

  def get_items() do
    Repo.all(from(b in Pmaster, where: b.type == "category" and b.active == ^"true"))
  end

  def getname(category) do
    Repo.one(
      from(
        b in Pmaster,
        where: b.id == ^category and b.type == "category" and b.active == ^"true",
        select: b.names
      )
    )
  end

  def get_max(category) do
    Repo.one(
      from(
        b in Pmaster,
        where: b.id == ^category and b.type == "category" and b.active == ^"true",
        select: b.max
      )
    )
  end

  def get_min(category) do
    Repo.one(
      from(
        b in Pmaster,
        where: b.id == ^category and b.type == "category" and b.active == ^"true",
        select: b.min
      )
    )
  end

  def get_items_id() do
    Repo.all(
      from(
        b in Pmaster,
        where: b.type == "category" and b.active == ^"true",
        select: {b.names, b.id}
      )
    )
  end

  def get_warehouse_value() do
    Repo.one(
      from(
        b in Pmaster,
        where: b.id == ^1 and b.type == "module" and b.active == ^"true",
        select: b.max
      )
    )
  end
end
