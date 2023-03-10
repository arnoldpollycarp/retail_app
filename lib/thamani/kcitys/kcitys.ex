defmodule Thamani.Kcitys do
  @moduledoc """
  The Kcitys context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Kcitys.KCity

  @doc """
  Returns the list of kcity.

  ## Examples

      iex> list_kcity()
      [%KCity{}, ...]

  """
  def list_kcity do
    Repo.all(KCity)
  end

  @doc """
  Gets a single k_city.

  Raises `Ecto.NoResultsError` if the K city does not exist.

  ## Examples

      iex> get_k_city!(123)
      %KCity{}

      iex> get_k_city!(456)
      ** (Ecto.NoResultsError)

  """
  def get_k_city!(id), do: Repo.get!(KCity, id)

  @doc """
  Creates a k_city.

  ## Examples

      iex> create_k_city(%{field: value})
      {:ok, %KCity{}}

      iex> create_k_city(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_k_city(attrs \\ %{}) do
    %KCity{}
    |> KCity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a k_city.

  ## Examples

      iex> update_k_city(k_city, %{field: new_value})
      {:ok, %KCity{}}

      iex> update_k_city(k_city, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_k_city(%KCity{} = k_city, attrs) do
    k_city
    |> KCity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a KCity.

  ## Examples

      iex> delete_k_city(k_city)
      {:ok, %KCity{}}

      iex> delete_k_city(k_city)
      {:error, %Ecto.Changeset{}}

  """
  def delete_k_city(%KCity{} = k_city) do
    Repo.delete(k_city)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking k_city changes.

  ## Examples

      iex> change_k_city(k_city)
      %Ecto.Changeset{source: %KCity{}}

  """
  def change_k_city(%KCity{} = k_city) do
    KCity.changeset(k_city, %{})
  end

  def list_cities() do
    Repo.all(
      from(
        b in KCity,
        select: {fragment("concat(?, ' ( ', ?,' County) ' )", b.city, b.county), b.id}
      )
    )
  end
end
