defmodule Thamani.Retail_Returns do
  @moduledoc """
  The Retail_Returns context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Retail_Returns.Retail_Return

  @doc """
  Returns the list of retail_returns.

  ## Examples

      iex> list_retail_returns()
      [%Retail_Return{}, ...]

  """
  def list_retail_returns do
    Retail_Return
    |> Repo.all()
    |> Repo.preload(:sku)
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  def list_recieved(companies) do
    Dispatch

    Repo.all(from(d in Retail_Return, where: d.company == ^companies))
    |> Repo.preload(:sku)
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single retail__return.

  Raises `Ecto.NoResultsError` if the Retail  return does not exist.

  ## Examples

      iex> get_retail__return!(123)
      %Retail_Return{}

      iex> get_retail__return!(456)
      ** (Ecto.NoResultsError)

  """
  def get_retail_return!(id) do
    Retail_Return
    |> Repo.get!(id)
    |> Repo.preload(:sku)
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  def get_recieved(companies, id) do
    Dispatch

    Repo.one(from(d in Retail_Return, where: d.company == ^companies and d.id == ^id))
    |> Repo.preload(:sku)
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a retail__return.

  ## Examples

      iex> create_retail__return(%{field: value})
      {:ok, %Retail_Return{}}

      iex> create_retail__return(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_retail__return(attrs \\ %{}) do
    %Retail_Return{}
    |> Retail_Return.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a retail__return.

  ## Examples

      iex> update_retail__return(retail__return, %{field: new_value})
      {:ok, %Retail_Return{}}

      iex> update_retail__return(retail__return, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_retail__return(%Retail_Return{} = retail__return, attrs) do
    retail__return
    |> Retail_Return.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Retail_Return.

  ## Examples

      iex> delete_retail__return(retail__return)
      {:ok, %Retail_Return{}}

      iex> delete_retail__return(retail__return)
      {:error, %Ecto.Changeset{}}

  """
  def delete_retail__return(%Retail_Return{} = retail__return) do
    Repo.delete(retail__return)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking retail__return changes.

  ## Examples

      iex> change_retail__return(retail__return)
      %Ecto.Changeset{source: %Retail_Return{}}

  """
  def change_retail__return(%Retail_Return{} = retail__return) do
    Retail_Return.changeset(retail__return, %{})
  end

  def get_count_recieved(current_user) do
    Repo.one(
      from(
        d in Retail_Return,
        where: d.company == ^current_user.id and d.active == ^"false",
        select: count(d.id)
      )
    )
  end

  def get_count_recieved_all() do
    Repo.one(from(d in Retail_Return, where: d.active == ^"false", select: count(d.id)))
  end
end
