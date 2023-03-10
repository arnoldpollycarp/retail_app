defmodule Thamani.Floats do
  @moduledoc """
  The Floats context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Floats.Float
  alias Thamani.Sales.Sale

  @doc """
  Returns the list of float.

  ## Examples

      iex> list_float()
      [%Float{}, ...]

  """
  def list_float do
    Repo.all(Float)
  end

  @doc """
  Gets a single float.

  Raises `Ecto.NoResultsError` if the Float does not exist.

  ## Examples

      iex> get_float!(123)
      %Float{}

      iex> get_float!(456)
      ** (Ecto.NoResultsError)

  """
  def get_float!(id), do: Repo.get!(Float, id)

  @doc """
  Creates a float.

  ## Examples

      iex> create_float(%{field: value})
      {:ok, %Float{}}

      iex> create_float(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_float(attrs \\ %{}) do
    %Float{}
    |> Float.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a float.

  ## Examples

      iex> update_float(float, %{field: new_value})
      {:ok, %Float{}}

      iex> update_float(float, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_float(%Float{} = float, attrs) do
    float
    |> Float.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Float.

  ## Examples

      iex> delete_float(float)
      {:ok, %Float{}}

      iex> delete_float(float)
      {:error, %Ecto.Changeset{}}

  """
  def delete_float(%Float{} = float) do
    Repo.delete(float)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking float changes.

  ## Examples

      iex> change_float(float)
      %Ecto.Changeset{source: %Float{}}

  """
  def change_float(%Float{} = float) do
    Float.changeset(float, %{})
  end

  def get_debit(current_user) do
    Repo.one(
      from(
        c in Sale,
        where: c.user_id == ^current_user.id and c.mode == ^"cash",
        select: sum(c.retailer)
      )
    )
  end

  def get_credit(current_user) do
    Repo.one(
      from(
        c in Float,
        where: c.user_id == ^current_user.id and c.type == ^"Credit",
        select: sum(c.amount)
      )
    )
  end

  def get_debit!() do
    Repo.one(from(c in Sale, where: c.mode == ^"cash", select: sum(c.retailer)))
  end

  def get_credit!() do
    Repo.one(from(c in Float, where: c.type == ^"Credit", select: sum(c.amount)))
  end

  def list_5_credit(current_user) do
    Repo.all(
      from(
        c in Float,
        order_by: [desc: c.id],
        preload: [:user],
        where: c.user_id == ^current_user.id and c.type == ^"credit",
        limit: 5
      )
    )
  end

  def list_5_debit(current_user) do
    Repo.all(
      from(
        c in Sale,
        order_by: [desc: c.id],
        preload: [:sku],
        where: c.user_id == ^current_user.id and c.mode == ^"cash",
        limit: 5
      )
    )
  end

  def list_5_credit!() do
    Repo.all(
      from(
        c in Float,
        order_by: [desc: c.id],
        preload: [:user],
        where: c.type == ^"credit",
        limit: 5
      )
    )
  end

  def list_5_debit!() do
    Repo.all(
      from(c in Sale, order_by: [desc: c.id], preload: [:sku], where: c.mode == ^"cash", limit: 5)
    )
  end

  def get_count_accounts() do
    Repo.one(from(f in Float, select: count(f.user_id, :distinct)))
  end
end
