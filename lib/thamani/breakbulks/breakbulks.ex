defmodule Thamani.Breakbulks do
  @moduledoc """
  The Breakbulks context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Breakbulks.Breakbulk
  alias Thamani.Dispatches.Dispatch
  alias Thamani.Items.Sku
  @doc """
  Returns the list of breakbulk.

  ## Examples

      iex> list_breakbulk()
      [%Breakbulk{}, ...]

  """
  def list_breakbulk do
    Repo.all(Breakbulk)
  end

  def list_breakbulk_code(code) do
    Breakbulk
    Repo.all(from(d in Breakbulk, where: d.code == ^code, preload: [:dispatch], preload: [:user]))
  end

  def list_breakbulk_id(code) do
    Breakbulk
    Repo.all(from(d in Breakbulk, where: d.id == ^code, preload: [:dispatch]))
  end

  def list_breakbulk!(current_user) do
    Breakbulk

    Repo.all(
      from(d in Breakbulk, where: d.user_id == ^current_user, distinct: true, select: d.code)
    )
  end

  def list_breakbulk_admin!() do
    Breakbulk
    Repo.all(from(d in Breakbulk, distinct: true, select: d.code))
  end

  def list_breakbulk_active(current_user) do
    Breakbulk

    Repo.all(
      from(d in Breakbulk, where: d.user_id == ^current_user, distinct: true, select: d.active)
    )
  end

  def list_breakbulk_admin_active() do
    Breakbulk
    Repo.all(from(d in Breakbulk, distinct: true, select: d.active))
  end

  def list_breakbulk_units(code) do
    Repo.one(from(d in Breakbulk, where: d.code == ^code, select: count(d.id)))
  end

  def list_breakbulk_quantity(code) do
    Repo.one(from(d in Breakbulk, where: d.code == ^code, select: sum(d.quantity)))
  end



  @doc """
  Gets a single breakbulk.

  Raises `Ecto.NoResultsError` if the Breakbulk does not exist.

  ## Examples

      iex> get_breakbulk!(123)
      %Breakbulk{}

      iex> get_breakbulk!(456)
      ** (Ecto.NoResultsError)

  """
  def get_breakbulk!(id), do: Repo.get!(Breakbulk, id)

  @doc """
  Creates a breakbulk.

  ## Examples

      iex> create_breakbulk(%{field: value})
      {:ok, %Breakbulk{}}

      iex> create_breakbulk(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_breakbulk(attrs \\ %{}) do
    %Breakbulk{}
    |> Breakbulk.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a breakbulk.

  ## Examples

      iex> update_breakbulk(breakbulk, %{field: new_value})
      {:ok, %Breakbulk{}}

      iex> update_breakbulk(breakbulk, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_breakbulk(%Breakbulk{} = breakbulk, attrs) do
    breakbulk
    |> Breakbulk.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Breakbulk.

  ## Examples

      iex> delete_breakbulk(breakbulk)
      {:ok, %Breakbulk{}}

      iex> delete_breakbulk(breakbulk)
      {:error, %Ecto.Changeset{}}

  """
  def delete_breakbulk(%Breakbulk{} = breakbulk) do
    Repo.delete(breakbulk)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking breakbulk changes.

  ## Examples

      iex> change_breakbulk(breakbulk)
      %Ecto.Changeset{source: %Breakbulk{}}

  """
  def change_breakbulk(%Breakbulk{} = breakbulk) do
    Breakbulk.changeset(breakbulk, %{})
  end

  def check_item(order_id) do
    Repo.one(from(d in Breakbulk, where: d.code == ^order_id, select: count(d.id)))
  end

    def get_sku_name(item) do
    Repo.one(from(s in Sku, where: s.id == ^item, select: s.name))
  end

  def get_sku_gtin(item) do
    Repo.one(from(s in Sku, where: s.id == ^item, select: s.gtin))
  end

  def get_sku_batch(item) do
      Repo.one(from(d in Dispatch, where: d.id == ^item, select: d.batch))
  end

  def get_sku_price(item) do
    Repo.one(from(s in Sku, where: s.id == ^item, select: s.price))
  end
end
