defmodule Thamani.Dispatches_Warehouse do
  @moduledoc """
  The Dispatches_Warehouse context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Dispatches_Warehouse.Dispatch_Warehouse
  alias Thamani.Dispatches.Dispatch
  alias Thamani.Items.Sku
  alias Thamani.Accounts.User
  alias Thamani.Pmasters.Pmaster

  @doc """
  Returns the list of dispatches_warehouse.

  ## Examples

      iex> list_dispatches_warehouse()
      [%Dispatch_Warehouse{}, ...]

  """
  def list_dispatches_warehouse do
    Dispatch_Warehouse
    |> Repo.all()
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  def list_recieved(companies) do
    Dispatch

    Repo.all(from(d in Dispatch_Warehouse, where: d.retailer == ^companies))
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  def list_recieved_all() do
    Dispatch
    |> Repo.all()
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single dispatch__warehouse.

  Raises `Ecto.NoResultsError` if the Dispatch  warehouse does not exist.

  ## Examples

      iex> get_dispatch__warehouse!(123)
      %Dispatch_Warehouse{}

      iex> get_dispatch__warehouse!(456)
      ** (Ecto.NoResultsError)

  """
  def get_dispatch__warehouse!(id) do
    Dispatch_Warehouse
    |> Repo.get!(id)
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  def get_recieved(companies, id) do
    Dispatch

    Repo.one(from(d in Dispatch_Warehouse, where: d.retailer == ^companies and d.id == ^id))
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  def get_recieved_all(id) do
    Dispatch
    |> Repo.one(from(d in Dispatch_Warehouse, where: d.id == ^id))
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a dispatch__warehouse.

  ## Examples

      iex> create_dispatch__warehouse(%{field: value})
      {:ok, %Dispatch_Warehouse{}}

      iex> create_dispatch__warehouse(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_dispatch__warehouse(attrs \\ %{}) do
    %Dispatch_Warehouse{}
    |> Dispatch_Warehouse.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a dispatch__warehouse.

  ## Examples

      iex> update_dispatch__warehouse(dispatch__warehouse, %{field: new_value})
      {:ok, %Dispatch_Warehouse{}}

      iex> update_dispatch__warehouse(dispatch__warehouse, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_dispatch__warehouse(%Dispatch_Warehouse{} = dispatch__warehouse, attrs) do
    dispatch__warehouse
    |> Dispatch_Warehouse.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Dispatch_Warehouse.

  ## Examples

      iex> delete_dispatch__warehouse(dispatch__warehouse)
      {:ok, %Dispatch_Warehouse{}}

      iex> delete_dispatch__warehouse(dispatch__warehouse)
      {:error, %Ecto.Changeset{}}

  """
  def delete_dispatch__warehouse(%Dispatch_Warehouse{} = dispatch__warehouse) do
    Repo.delete(dispatch__warehouse)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dispatch__warehouse changes.

  ## Examples

      iex> change_dispatch__warehouse(dispatch__warehouse)
      %Ecto.Changeset{source: %Dispatch_Warehouse{}}

  """
  def change_dispatch__warehouse(%Dispatch_Warehouse{} = dispatch__warehouse) do
    Dispatch_Warehouse.changeset(dispatch__warehouse, %{})
  end

  def get_count_dispatch(current_user) do
    Repo.one(
      from(d in Dispatch_Warehouse, where: d.user_id == ^current_user.id, select: count(d.id))
    )
  end

  def get_count_dispatch_all() do
    Repo.one(from(d in Dispatch_Warehouse, select: count(d.id)))
  end

  def get_count_dispatch_value(current_user) do
    Repo.one(
      from(d in Dispatch_Warehouse, where: d.user_id == ^current_user.id, select: sum(d.total))
    )
  end

  def get_count_dispatch_value_all() do
    Repo.one(from(d in Dispatch_Warehouse, select: sum(d.total)))
  end

  def get_count_quantity(current_user) do
    Repo.one(
      from(d in Dispatch_Warehouse, where: d.user_id == ^current_user.id, select: sum(d.quantity))
    )
  end

  def get_count_quantity_all() do
    Repo.one(from(d in Dispatch_Warehouse, select: sum(d.quantity)))
  end

  def get_count_quantity_item(current_user, item) do
    Repo.one(
      from(
        d in Dispatch_Warehouse,
        where: d.user_id == ^current_user.id and d.item == ^item,
        select: sum(d.quantity)
      )
    )
  end

  def get_count_quantity_item_retail(current_user, item) do
    Repo.one(
      from(
        d in Dispatch_Warehouse,
        where: d.retailer == ^current_user.id and d.item == ^item,
        select: sum(d.quantity)
      )
    )
  end

  def get_count_confirmed(current_user) do
    Repo.one(
      from(
        d in Dispatch_Warehouse,
        where: d.user_id == ^current_user.id and d.active == ^"true",
        select: count(d.active)
      )
    )
  end

  def get_count_confirmed_all() do
    Repo.one(from(d in Dispatch_Warehouse, where: d.active == ^"true", select: count(d.active)))
  end

  def get_price(item) do
    Repo.one(from(d in Sku, where: d.id == ^item, select: d.price))
  end

  def get_count_recieved(companies) do
    Repo.one(from(d in Dispatch_Warehouse, where: d.retailer == ^companies, select: count(d.id)))
  end

  def get_count_recieved_all() do
    Repo.one(from(d in Dispatch_Warehouse, select: count(d.id)))
  end

  def get_count_recieved!(companies) do
    Repo.one(
      from(
        d in Dispatch_Warehouse,
        where: d.retailer == ^companies and d.active == ^"false",
        select: count(d.id)
      )
    )
  end

  def get_count_recieved_all!() do
    Repo.one(from(d in Dispatch_Warehouse, where: d.active == ^"false", select: count(d.id)))
  end

  def get_items(current_user) do
    Repo.all(
      from(
        b in Dispatch,
        where: b.warehouse == ^current_user.id and b.active == ^"true",
        select: {b.shipping, b.item}
      )
    )
  end

  def get_company() do
    Repo.all(
      from(c in User, where: not c.userlevel and c.active == ^"true", select: {c.company, c.id})
    )
  end

  def get_dispatches(current_user) do
    Repo.all(
      from(
        d in Dispatch_Warehouse,
        where: d.user_id == ^current_user.id,
        order_by: [desc: d.id],
        preload: [:companies],
        limit: 5
      )
    )
  end

  def get_dispatches_all() do
    Repo.all(
      from(d in Dispatch_Warehouse, order_by: [desc: d.id], preload: [:companies], limit: 5)
    )
  end

  def get_retailer_name(retailer) do
    Repo.one(from(d in User, where: d.id == ^retailer, select: d.company))
  end

  def get_last_id() do
    Repo.one(from(d in Dispatch_Warehouse, select: max(d.id)))
  end

  def get_warehouse_value() do
    Repo.one(from(p in Pmaster, where: p.name == "warehouse", select: p.max))
  end
  

end
