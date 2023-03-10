defmodule Thamani.Batches do
  @moduledoc """
  The Batches context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Batches.Batch
  alias Thamani.Items.Sku

  @doc """
  Returns the list of batches.

  ## Examples

      iex> list_batches()
      [%Batch{}, ...]

  """
  def list_batches do
    Batch
    |> Repo.all()
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single batch.

  Raises `Ecto.NoResultsError` if the Batch does not exist.

  ## Examples

      iex> get_batch!(123)
      %Batch{}

      iex> get_batch!(456)
      ** (Ecto.NoResultsError)

  """
  def get_batch!(id) do
    Batch
    |> Repo.get!(id)
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a batch.

  ## Examples

      iex> create_batch(%{field: value})
      {:ok, %Batch{}}

      iex> create_batch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_batch(attrs \\ %{}) do
    %Batch{}
    |> Batch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a batch.

  ## Examples

      iex> update_batch(batch, %{field: new_value})
      {:ok, %Batch{}}

      iex> update_batch(batch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_batch(%Batch{} = batch, attrs) do
    batch
    |> Batch.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Batch.

  ## Examples

      iex> delete_batch(batch)
      {:ok, %Batch{}}

      iex> delete_batch(batch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_batch(%Batch{} = batch) do
    Repo.delete(batch)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking batch changes.

  ## Examples

      iex> change_batch(batch)
      %Ecto.Changeset{source: %Batch{}}

  """
  def change_batch(%Batch{} = batch) do
    Batch.changeset(batch, %{})
  end

  def get_count_batches(current_user) do
    Repo.one(from(d in Batch, where: d.user_id == ^current_user.id, select: count(d.id)))
  end

  def get_count_batches_all() do
    Repo.one(from(d in Batch, select: count(d.id)))
  end

  def get_batch_alone(item) do
    Repo.one(from(d in Batch, where: d.id == ^item, select: d.batch))
  end

  def get_expiry!(item) do
    Repo.one(from(d in Batch, where: d.id == ^item, select: d.expiry))
  end

  def get_item_id!(item) do
    Repo.one(from(d in Batch, where: d.id == ^item, select: d.item))
  end

  def get_production!(item) do
    Repo.one(from(d in Batch, where: d.id == ^item, select: d.production))
  end

  def get_batch(item) do
    Repo.one(
      from(
        d in Batch,
        join: c in Sku,
        where: d.id == ^item and d.item == c.id,
        select:
          fragment("concat('01',?,'10',?,'17',?,'11',?)", c.gtin, d.batch, d.expiry, d.production)
      )
    )
  end

  def get_batch_!(item) do
    Repo.one(
      from(
        d in Batch,
        join: c in Sku,
        where: d.id == ^item and d.item == c.id,
        select:
          fragment(
            "concat(' (01) ',?,' (10) ',?,' (17) ', ?,' (11) ', ?)",
            c.gtin,
            d.batch,
            d.expiry,
            d.production
          )
      )
    )
  end

  def get_name(item) do
    Repo.one(
      from(d in Batch, join: c in Sku, where: d.id == ^item and d.item == c.id, select: c.name, limit: 1)
    )
  end
end
