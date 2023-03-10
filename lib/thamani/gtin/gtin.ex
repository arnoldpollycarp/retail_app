defmodule Thamani.GTIN do
  @moduledoc """
  The GTIN context.
  """
  import Ecto.Query, warn: false
  alias Thamani.Repo
  use Rummage.Ecto
  alias Thamani.GTIN.Barcode

  @doc """
  Returns the list of barcode.

  ## Examples

      iex> list_barcode()
      [%Barcode{}, ...]

  """
  def list_barcode do
    Repo.all(Barcode)
  end

  @doc """
  Gets a single barcode.

  Raises `Ecto.NoResultsError` if the Barcode does not exist.

  ## Examples

      iex> get_barcode!(123)
      %Barcode{}

      iex> get_barcode!(456)
      ** (Ecto.NoResultsError)

  """
  def get_barcode!(id), do: Repo.get!(Barcode, id)

  @doc """
  Creates a barcode.

  ## Examples

      iex> create_barcode(%{field: value})
      {:ok, %Barcode{}}

      iex> create_barcode(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_barcode(attrs \\ %{}) do
    %Barcode{}
    |> Barcode.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a barcode.

  ## Examples

      iex> update_barcode(barcode, %{field: new_value})
      {:ok, %Barcode{}}

      iex> update_barcode(barcode, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_barcode(%Barcode{} = barcode, attrs) do
    barcode
    |> Barcode.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Barcode.

  ## Examples

      iex> delete_barcode(barcode)
      {:ok, %Barcode{}}

      iex> delete_barcode(barcode)
      {:error, %Ecto.Changeset{}}

  """
  def delete_barcode(%Barcode{} = barcode) do
    Repo.delete(barcode)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking barcode changes.

  ## Examples

      iex> change_barcode(barcode)
      %Ecto.Changeset{source: %Barcode{}}

  """
  def change_barcode(%Barcode{} = barcode) do
    Barcode.changeset(barcode, %{})
  end

  def get_count_gtin() do
    Repo.one(from(u in Barcode, select: count(u.id)))
  end
end
