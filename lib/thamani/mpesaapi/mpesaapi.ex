defmodule Thamani.Mpesaapi do
  @moduledoc """
  The Mpesaapi context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Mpesaapi.Mpesa

  @doc """
  Returns the list of mpesa.

  ## Examples

      iex> list_mpesa()
      [%Mpesa{}, ...]

  """
  def list_mpesa do
    Repo.all(Mpesa)
  end

  @doc """
  Gets a single mpesa.

  Raises `Ecto.NoResultsError` if the Mpesa does not exist.

  ## Examples

      iex> get_mpesa!(123)
      %Mpesa{}

      iex> get_mpesa!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mpesa!(id), do: Repo.get!(Mpesa, id)

  @doc """
  Creates a mpesa.

  ## Examples

      iex> create_mpesa(%{field: value})
      {:ok, %Mpesa{}}

      iex> create_mpesa(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mpesa(attrs \\ %{}) do
    %Mpesa{}
    |> Mpesa.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a mpesa.

  ## Examples

      iex> update_mpesa(mpesa, %{field: new_value})
      {:ok, %Mpesa{}}

      iex> update_mpesa(mpesa, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mpesa(%Mpesa{} = mpesa, attrs) do
    mpesa
    |> Mpesa.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Mpesa.

  ## Examples

      iex> delete_mpesa(mpesa)
      {:ok, %Mpesa{}}

      iex> delete_mpesa(mpesa)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mpesa(%Mpesa{} = mpesa) do
    Repo.delete(mpesa)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mpesa changes.

  ## Examples

      iex> change_mpesa(mpesa)
      %Ecto.Changeset{source: %Mpesa{}}

  """
  def change_mpesa(%Mpesa{} = mpesa) do
    Mpesa.changeset(mpesa, %{})
  end

  def check_record(code) do
    Repo.one(from(u in Mpesa, where: u.description == ^code, select: count(u.id)))
  end
end
