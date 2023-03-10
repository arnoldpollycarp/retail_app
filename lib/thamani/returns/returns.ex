defmodule Thamani.Returns do
  @moduledoc """
  The Returns context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Returns.Return

  @doc """
  Returns the list of returns.

  ## Examples

      iex> list_returns()
      [%Return{}, ...]

  """
  def list_returns do
    Return
    |> Repo.all()
    |> Repo.preload(:sku)
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  def list_recieved(companies) do
    Return

    Repo.all(from(d in Return, where: d.company == ^companies))
    |> Repo.preload(:sku)
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single return.

  Raises `Ecto.NoResultsError` if the Return does not exist.

  ## Examples

      iex> get_return!(123)
      %Return{}

      iex> get_return!(456)
      ** (Ecto.NoResultsError)

  """
  def get_return!(id) do
    Return
    |> Repo.get!(id)
    |> Repo.preload(:sku)
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  def get_recieved(companies, id) do
    Dispatch

    Repo.one(from(d in Return, where: d.company == ^companies and d.id == ^id))
    |> Repo.preload(:sku)
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a return.

  ## Examples

      iex> create_return(%{field: value})
      {:ok, %Return{}}

      iex> create_return(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_return(attrs \\ %{}) do
    %Return{}
    |> Return.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a return.

  ## Examples

      iex> update_return(return, %{field: new_value})
      {:ok, %Return{}}

      iex> update_return(return, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_return(%Return{} = return, attrs) do
    return
    |> Return.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Return.

  ## Examples

      iex> delete_return(return)
      {:ok, %Return{}}

      iex> delete_return(return)
      {:error, %Ecto.Changeset{}}

  """
  def delete_return(%Return{} = return) do
    Repo.delete(return)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking return changes.

  ## Examples

      iex> change_return(return)
      %Ecto.Changeset{source: %Return{}}

  """
  def change_return(%Return{} = return) do
    Return.changeset(return, %{})
  end

  def get_count_recieved(current_user) do
    Repo.one(
      from(
        d in Return,
        where: d.company == ^current_user.id and d.active == ^"false",
        select: count(d.id)
      )
    )
  end

  def get_count_recieved_all() do
    Repo.one(from(d in Return, where: d.active == ^"false", select: count(d.id)))
  end
end
