defmodule Thamani.Retman_orders do
  @moduledoc """
  The Retman_orders context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Items.Sku
  alias Thamani.Accounts.User

  alias Thamani.Retman_orders.Retman_order

  @doc """
  Returns the list of retman_orders.

  ## Examples

      iex> list_retman_orders()
      [%Retman_order{}, ...]

  """
  def list_retman_orders do
    Retman_order
    |> Repo.all()
    |> Repo.preload(:sku)
    |> Repo.preload(:kcity)
    |> Repo.preload(:company)
    |> Repo.preload(:user)
    |> Repo.preload(:pmaster)
  end

  def list_orders_retman(mid) do
    Retman_order

    Repo.all(from(d in Retman_order, where: d.manufacturer == ^mid))
    |> Repo.preload(:sku)
    |> Repo.preload(:company)
    |> Repo.preload(:user)
    |> Repo.preload(:kcity)
    |> Repo.preload(:pmaster)
  end

  def list_sku_name(cat) do
    Sku

    Repo.all(
      from(
        s in Sku,
        join: c in User,
        where: s.category == ^cat and s.user_id == c.id and c.manufacturer == ^"1"
      )
    )
    |> Repo.preload(:user)
  end

  def list_uom(item) do
    Repo.all(
      from(
        s in Sku,
        where: s.id == ^item,
        select: [fragment("concat(?, ' ( ', ?,' ) ')", s.weight2, s.min_quantity)]
      )
    )
  end

  def get_manufacturer(item) do
    Repo.all(
      from(
        s in Sku,
        join: c in User,
        where: s.id == ^item and s.user_id == c.id,
        select: c.company,
        limit: 1
      )
    )
  end

  def get_manufacturer_id(item) do
    Repo.all(
      from(
        s in Sku,
        join: c in User,
        where: s.id == ^item and s.user_id == c.id,
        select: c.id,
        limit: 1
      )
    )
  end

  def get_delivery(item) do
    Repo.all(from(s in Sku, where: s.id == ^item, select: s.delivery, limit: 1))
  end

  def get_min_quantity(item) do
    Repo.all(from(s in Sku, where: s.id == ^item, select: s.min_quantity, limit: 1))
  end

  def get_sku(item) do
    Sku

    Repo.all(
      from(
        s in Sku,
        join: c in User,
        where: s.id == ^item and s.user_id == c.id and c.manufacturer == ^"1"
      )
    )
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single retman_order.

  Raises `Ecto.NoResultsError` if the Retman order does not exist.

  ## Examples

      iex> get_retman_order!(123)
      %Retman_order{}

      iex> get_retman_order!(456)
      ** (Ecto.NoResultsError)

  """

  def get_retman_order!(id) do
    Retman_order
    |> Repo.get!(id)
    |> Repo.preload(:sku)
    |> Repo.preload(:kcity)
    |> Repo.preload(:company)
    |> Repo.preload(:user)
    |> Repo.preload(:pmaster)
  end

  def get_orders_retman(mid, id) do
    Repo.one(from(d in Retman_order, where: d.manufacturer == ^mid and d.id == ^id))
    |> Repo.preload(:sku)
    |> Repo.preload(:kcity)
    |> Repo.preload(:company)
    |> Repo.preload(:pmaster)
  end

  @doc """
  Creates a retman_order.

  ## Examples

      iex> create_retman_order(%{field: value})
      {:ok, %Retman_order{}}

      iex> create_retman_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_retman_order(attrs \\ %{}) do
    %Retman_order{}
    |> Retman_order.changeset(attrs)
    |> Repo.insert()
  end

  def create_orders(
        cid,
        category,
        item,
        delivery,
        city,
        manufacturer,
        quantity,
        description,
        current_user
      ) do
    %Retman_order{
      order_id: cid,
      category: category,
      item: item,
      delivery: delivery,
      city: city,
      manufacturer: manufacturer,
      quantity: quantity,
      description: description,
      user_id: current_user
    }
    |> Repo.insert()
  end

  @doc """
  Updates a retman_order.

  ## Examples

      iex> update_retman_order(retman_order, %{field: new_value})
      {:ok, %Retman_order{}}

      iex> update_retman_order(retman_order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_retman_order(%Retman_order{} = retman_order, attrs) do
    retman_order
    |> Retman_order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Retman_order.

  ## Examples

      iex> delete_retman_order(retman_order)
      {:ok, %Retman_order{}}

      iex> delete_retman_order(retman_order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_retman_order(%Retman_order{} = retman_order) do
    Repo.delete(retman_order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking retman_order changes.

  ## Examples

      iex> change_retman_order(retman_order)
      %Ecto.Changeset{source: %Retman_order{}}

  """
  def change_retman_order(%Retman_order{} = retman_order) do
    Retman_order.changeset(retman_order, %{})
  end

  def get_count_order(current_user) do
    Repo.one(
      from(
        d in Retman_order,
        where: d.manufacturer == ^current_user.id and d.active == ^"false",
        select: count(d.id)
      )
    )
  end

  def get_count_order_all() do
    Repo.one(from(d in Retman_order, where: d.active == ^"false", select: count(d.id)))
  end
end
