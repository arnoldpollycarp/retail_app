defmodule Thamani.Dispatches do
  @moduledoc """
  The Dispatches context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo
  alias Thamani.Batches.Batch
  alias Thamani.Dispatches.Dispatch
  alias Thamani.Items.Sku
  alias Thamani.Accounts.User
  alias Thamani.Breakbulks.Breakbulk

  @doc """
  Returns the list of values.

  ## Examples

      iex> list_dispatches()
      [%Dispatch{}, ...]

  """
  def list_dispatches do
    Dispatch
    |> Repo.all()
    |> Repo.preload(:companies)
    |> Repo.preload(:company)
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  def list_inventory_by_expiry(date_1, date, user_id) do
    Repo.all(
      from(
        d in Dispatch,
        where: d.expiry >= ^date and d.expiry <= ^date_1 and d.warehouse == ^user_id.id
      )
    )
    |> Repo.preload(:sku)
    |> Repo.preload(:company)
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  def list_recieved(companies) do
    Dispatch

    Repo.all(from(d in Dispatch, where: d.warehouse == ^companies))
    |> Repo.preload(:sku)
    |> Repo.preload(:company)
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  def list_recieved_all() do
    Dispatch
    |> Repo.all()
    |> Repo.preload(:sku)
    |> Repo.preload(:company)
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single dispatch.

  Raises `Ecto.NoResultsError` if the Dispatch does not exist.

  ## Examples

      iex> get_dispatch!(123)
      %Dispatch{}

      iex> get_dispatch!(456)
      ** (Ecto.NoResultsError)

  """
  def get_dispatch!(id) do
    Dispatch
    |> Repo.get!(id)
    |> Repo.preload(:sku)
    |> Repo.preload(:company)
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  def get_recieved(companies, id) do
    Dispatch

    Repo.one(from(d in Dispatch, where: d.warehouse == ^companies and d.id == ^id))
    |> Repo.preload(:sku)
    |> Repo.preload(:company)
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  def get_recieved_all(id) do
    Dispatch

    Repo.one(from(d in Dispatch, where: d.id == ^id))
    |> Repo.preload(:sku)
    |> Repo.preload(:company)
    |> Repo.preload(:companies)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a dispatch.

  ## Examples

      iex> create_dispatch(%{field: value})
      {:ok, %Dispatch{}}

      iex> create_dispatch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_dispatch(attrs \\ %{}) do
    %Dispatch{}
    |> Dispatch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a dispatch.

  ## Examples

      iex> update_dispatch(dispatch, %{field: new_value})
      {:ok, %Dispatch{}}

      iex> update_dispatch(dispatch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_dispatch(%Dispatch{} = dispatch, attrs) do
    dispatch
    |> Dispatch.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Dispatch.

  ## Examples

      iex> delete_dispatch(dispatch)
      {:ok, %Dispatch{}}

      iex> delete_dispatch(dispatch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_dispatch(%Dispatch{} = dispatch) do
    Repo.delete(dispatch)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dispatch changes.

  ## Examples

      iex> change_dispatch(dispatch)
      %Ecto.Changeset{source: %Dispatch{}}

  """
  def change_dispatch(%Dispatch{} = dispatch) do
    Dispatch.changeset(dispatch, %{})
  end

  def get_count_dispatch(current_user) do
    Repo.one(from(d in Dispatch, where: d.user_id == ^current_user.id, select: count(d.id)))
  end

  def get_count_dispatch_all() do
    Repo.one(from(d in Dispatch, select: count(d.id)))
  end

  def to_integer(attrs) do
    String.to_integer(Enum.join([attrs]))
  end

  def get_count_dispatch_value(current_user) do
    Repo.one(from(d in Dispatch, where: d.user_id == ^current_user.id, select: sum(d.total)))
  end

  def get_dispatch_value(current_user, id) do
    Repo.one(
      from(
        d in Dispatch,
        where: d.user_id == ^current_user.id and d.id == ^id,
        select: sum(d.total)
      )
    )
  end

  def get_last_id() do
    Repo.one(from(d in Dispatch, select: max(d.id)))
  end

  def get_count_dispatch_value_all() do
    Repo.one(from(d in Dispatch, select: sum(d.total)))
  end

  def get_count_quantity(current_user) do
    Repo.one(from(d in Dispatch, where: d.user_id == ^current_user.id, select: sum(d.quantity)))
  end

  def get_count_quantity_all() do
    Repo.one(from(d in Dispatch, select: sum(d.quantity)))
  end

  def get_count_quantity_item(current_user, item) do
    Repo.one(
      from(
        d in Dispatch,
        where: d.warehouse == ^current_user.id and d.item == ^item,
        select: sum(d.quantity)
      )
    )
  end

  def get_count_confirmed(current_user) do
    Repo.one(
      from(
        d in Dispatch,
        where: d.user_id == ^current_user.id and d.active == ^"true",
        select: count(d.active)
      )
    )
  end

  def get_count_confirmed_all() do
    Repo.one(from(d in Dispatch, where: d.active == ^"true", select: count(d.active)))
  end

  def get_price(item) do
    Repo.one(from(d in Sku, where: d.id == ^item, select: fragment("sum(s0.`price` + s0.`markup`)")))
  end

  def get_count_recieved(companies) do
    Repo.one(from(d in Dispatch, where: d.warehouse == ^companies, select: count(d.id)))
  end

  def get_count_recieved_all() do
    Repo.one(from(d in Dispatch, select: count(d.id)))
  end

  def get_count_recieved!(companies) do
    Repo.one(
      from(
        d in Dispatch,
        where: d.warehouse == ^companies and d.active == ^"false",
        select: count(d.id)
      )
    )
  end

  def get_count_recieved_all!() do
    Repo.one(from(d in Dispatch, where: d.active == ^"false", select: count(d.id)))
  end

  def get_items(current_user) do
    Repo.all(
      from(
        b in Batch,
        join: c in Sku,
        where: b.item == c.id and b.user_id == ^current_user.id and b.active == ^"true",
        select:
          {fragment("concat(?, ' ( ', ?,' ) ', ' ( ', ?,' ) ')", c.gtin, c.name, b.batch), b.id}
      )
    )
  end

  def get_items_datalist(current_user) do
    Repo.all(
      from(
        b in Batch,
        join: c in Sku,
        where: b.item == c.id and b.user_id == ^current_user.id and b.active == ^"true",
        order_by: [desc: b.id],
        preload: [:sku]

    ))
  end

  def get_items_warehouse(current_user) do
    Repo.all(
      from(
        b in Dispatch,
        join: c in Sku,
        where: b.item == c.id and b.warehouse == ^current_user.id and b.active == ^"true",
        select: {b.shipping, b.item}
      )
    )
  end

  def get_company() do
    Repo.all(
      from(c in User, where: not c.userlevel and c.active == ^"true", select: {c.company, c.id})
    )
  end

  def get_company_datalist() do
    Repo.all(
      from(c in User, where: not c.userlevel and c.active == ^"true", order_by: [desc: c.id])
    )
  end

  def get_dispatches(current_user) do
    Repo.all(
      from(
        d in Dispatch,
        where: d.user_id == ^current_user.id,
        order_by: [desc: d.id],
        preload: [:sku],
        preload: [:companies],
        preload: [:company],
        limit: 5
      )
    )
  end

  def get_dispatches!() do
    Repo.all(
      from(
        d in Dispatch,
        order_by: [desc: d.id],
        preload: [:sku],
        preload: [:companies],
        preload: [:company],
        limit: 5
      )
    )
  end

  def get_recieved(current_user) do
    Repo.all(
      from(
        d in Dispatch,
        where: d.user_id == ^current_user.id,
        order_by: [desc: d.id],
        preload: [:batches],
        preload: [:users],
        limit: 5
      )
    )
  end

  def getcategoryname(item) do
    Repo.one(from(d in Sku, where: d.id == ^item, select: d.category, limit: 1))
  end

  def get_recieved_select(current_user) do
    Repo.all(
      from(
        d in Dispatch,
        join: c in Sku,
        where: d.item == c.id and d.warehouse == ^current_user and d.active == ^"true",
        order_by: [desc: d.id],
        select:
          {fragment("concat(?, ' ( ', ?,' ) ', ' ( ', ?,' ) ')", c.gtin, c.name, d.batch), d.id}
      )
    )
  end

  def get_recieved_select_datalist(current_user) do
    Repo.all(
      from(
        d in Dispatch,
        join: c in Sku,
        where: d.item == c.id and d.warehouse == ^current_user and d.active == ^"true",
        order_by: [desc: d.id],
        preload: [:sku]
    )
    )
  end

    def get_recieved_select_all(current_user) do
    Repo.all(
      from(
        d in Dispatch,
        join: c in Sku,
        where: d.item == c.id and d.warehouse == ^current_user and d.active == ^"true",
        order_by: [desc: d.id],
        preload: [:sku]

      )
    )
  end

  def get_recieved_select!(current_user) do
    Repo.all(
      from(
        d in Dispatch,
        where: d.warehouse == ^current_user and d.active == ^"true",
        order_by: [desc: d.id],
        select: {d.shipping, d.id}
      )
    )
  end

  def get_recieved_item(item) do
    Repo.one(from(d in Dispatch, where: d.id == ^item, select: d.item))
  end

  def get_warehouse_name(warehouse) do
    Repo.one(from(d in User, where: d.id == ^warehouse, select: d.company))
  end

  def get_warehouse_owner(warehouse) do
    Repo.one(
      from(
        d in User,
        where: d.id == ^warehouse,
        select: fragment("concat(?, '  ', ?)", d.firstname, d.lastname)
      )
    )
  end

  def get_warehouse_email(warehouse) do
    Repo.one(from(d in User, where: d.id == ^warehouse, select: d.email))
  end

  def get_warehouse_phone(warehouse) do
    Repo.one(from(d in User, where: d.id == ^warehouse, select: d.phone))
  end

  def get_quantity_delivered(item,warehouse) do
      Repo.one(from(d in Dispatch,join: c in Sku,where: d.item == ^ item and d.item == c.id and d.warehouse == ^warehouse, select: sum(d.quantity)))
  end
  def get_times_delivered(item,warehouse) do
      Repo.one(from(d in Dispatch,join: c in Sku,where: d.item == ^ item and d.item == c.id and d.warehouse == ^warehouse, select: count(d.id)))
  end

  def get_quantity_sent(item,warehouse) do
      Repo.one(from(b in Breakbulk,join: d in Dispatch ,where: d.item == ^ item and d.id == b.scode and d.warehouse == ^warehouse, select: sum(b.quantity)))
  end
  def get_times_sent(item,warehouse) do
      Repo.one(from(b in Breakbulk,join: d in Dispatch ,where: d.item == ^ item and d.id == b.scode and d.warehouse == ^warehouse, select: count(b.id)))
  end

end
