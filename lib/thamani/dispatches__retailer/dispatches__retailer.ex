defmodule Thamani.Dispatches_Retailer do
  @moduledoc """
  The Dispatches_Retailer context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo
  alias Thamani.Batches.Batch
  alias Thamani.Dispatches_Retailer.Dispatch_Retailer
  alias Thamani.Items.Sku
  alias Thamani.Accounts.User

  @doc """
  Returns the list of dispatches_retailer.

  ## Examples

      iex> list_dispatches_retailer()
      [%Dispatch_Retailer{}, ...]

  """
  def list_dispatches_retailer do
    Dispatch_Retailer
    |> Repo.all()
    |> Repo.preload(:company)
    |> Repo.preload(:sku)
    |> Repo.preload(:user)
  end

  def list_recieved(companies) do
    Dispatch_Retailer

    Repo.all(from(d in Dispatch_Retailer, where: d.retailer == ^companies))
    |> Repo.preload(:sku)
    |> Repo.preload(:company)
    |> Repo.preload(:user)
  end

  def list_recieved_all() do
    Dispatch_Retailer
    |> Repo.all()
    |> Repo.preload(:sku)
    |> Repo.preload(:company)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single dispatch__retailer.

  Raises `Ecto.NoResultsError` if the Dispatch  retailer does not exist.

  ## Examples

      iex> get_dispatch__retailer!(123)
      %Dispatch_Retailer{}

      iex> get_dispatch__retailer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_dispatch_retailer!(id) do
    Dispatch_Retailer
    |> Repo.get!(id)
    |> Repo.preload(:sku)
    |> Repo.preload(:company)
    |> Repo.preload(:user)
  end

  def get_recieved(companies, id) do
    Dispatch_Retailer

    Repo.one(from(d in Dispatch_Retailer, where: d.retailer == ^companies and d.id == ^id))
    |> Repo.preload(:sku)
    |> Repo.preload(:company)
    |> Repo.preload(:user)
  end

  def get_recieved_retail(companies, id) do
    Dispatch_Retailer

    Repo.all(from(d in Dispatch_Retailer, where: d.retailer == ^companies.id and d.id == ^id))
    |> Repo.preload(:sku)
    |> Repo.preload(:company)
    |> Repo.preload(:user)
  end

  def get_recieved_all(id) do
    Dispatch_Retailer

    Repo.one(from(d in Dispatch_Retailer, where: d.id == ^id))
    |> Repo.preload(:sku)
    |> Repo.preload(:company)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a dispatch__retailer.

  ## Examples

      iex> create_dispatch__retailer(%{field: value})
      {:ok, %Dispatch_Retailer{}}

      iex> create_dispatch__retailer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_dispatch__retailer(attrs \\ %{}) do
    %Dispatch_Retailer{}
    |> Dispatch_Retailer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a dispatch__retailer.

  ## Examples

      iex> update_dispatch__retailer(dispatch__retailer, %{field: new_value})
      {:ok, %Dispatch_Retailer{}}

      iex> update_dispatch__retailer(dispatch__retailer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_dispatch__retailer(%Dispatch_Retailer{} = dispatch__retailer, attrs) do
    dispatch__retailer
    |> Dispatch_Retailer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Dispatch_Retailer.

  ## Examples

      iex> delete_dispatch__retailer(dispatch__retailer)
      {:ok, %Dispatch_Retailer{}}

      iex> delete_dispatch__retailer(dispatch__retailer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_dispatch__retailer(%Dispatch_Retailer{} = dispatch__retailer) do
    Repo.delete(dispatch__retailer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dispatch__retailer changes.

  ## Examples

      iex> change_dispatch__retailer(dispatch__retailer)
      %Ecto.Changeset{source: %Dispatch_Retailer{}}

  """
  def change_dispatch__retailer(%Dispatch_Retailer{} = dispatch__retailer) do
    Dispatch_Retailer.changeset(dispatch__retailer, %{})
  end

  def get_count_dispatch(current_user) do
    Repo.one(
      from(d in Dispatch_Retailer, where: d.user_id == ^current_user.id, select: count(d.id))
    )
  end

  def get_count_dispatch_all() do
    Repo.one(from(d in Dispatch_Retailer, select: count(d.id)))
  end

  def to_integer(attrs) do
    String.to_integer(Enum.join([attrs]))
  end

  def get_count_dispatch_value(current_user) do
    Repo.one(
      from(d in Dispatch_Retailer, where: d.user_id == ^current_user.id, select: sum(d.total))
    )
  end

  def get_count_dispatch_value_all() do
    Repo.one(from(d in Dispatch_Retailer, select: sum(d.total)))
  end

  def get_count_quantity(current_user) do
    Repo.one(
      from(d in Dispatch_Retailer, where: d.user_id == ^current_user.id, select: sum(d.quantity))
    )
  end

  def get_count_quantity_all() do
    Repo.one(from(d in Dispatch_Retailer, select: sum(d.quantity)))
  end

  def get_count_quantity_item(current_user, item) do
    Repo.one(
      from(
        d in Dispatch_Retailer,
        where: d.retailer == ^current_user.id and d.item == ^item,
        select: sum(d.quantity)
      )
    )
  end

  def get_count_confirmed(current_user) do
    Repo.one(
      from(
        d in Dispatch_Retailer,
        where: d.user_id == ^current_user.id and d.active == ^"true",
        select: count(d.active)
      )
    )
  end

  def get_count_confirmed_all() do
    Repo.one(from(d in Dispatch_Retailer, where: d.active == ^"true", select: count(d.active)))
  end

  def get_price(item) do
    Repo.one(from(d in Sku, where: d.id == ^item, select: d.price))
  end

  def get_count_recieved(companies) do
    Repo.one(from(d in Dispatch_Retailer, where: d.retailer == ^companies, select: count(d.id)))
  end

  def get_count_recieved!(companies) do
    Repo.one(
      from(
        d in Dispatch_Retailer,
        where: d.retailer == ^companies and d.active == ^"false",
        select: count(d.id)
      )
    )
  end

  def get_count_recieved_all!() do
    Repo.one(from(d in Dispatch_Retailer, where: d.active == ^"false", select: count(d.id)))
  end

  def get_count_recieved_all() do
    Repo.one(from(d in Dispatch_Retailer, select: count(d.id)))
  end

  def get_last_id() do
    Repo.one(from(d in Dispatch_Retailer, select: max(d.id)))
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

  def get_company() do
    Repo.all(
      from(c in User, where: not c.userlevel and c.active == ^"true", select: {c.company, c.id})
    )
  end

  def get_dispatches(current_user) do
    Repo.all(
      from(
        d in Dispatch_Retailer,
        where: d.user_id == ^current_user.id,
        order_by: [desc: d.id],
        preload: [:sku],
        preload: [:company],
        limit: 5
      )
    )
  end

  def get_dispatches!() do
    Repo.all(
      from(
        d in Dispatch_Retailer,
        order_by: [desc: d.id],
        preload: [:sku],
        preload: [:company],
        limit: 5
      )
    )
  end

  def get_recieved(current_user) do
    Repo.all(
      from(
        d in Dispatch_Retailer,
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
        d in Dispatch_Retailer,
        where: d.retailer == ^current_user.id,
        order_by: [desc: d.id],
        select: {d.shipping, d.id}
      )
    )
  end

  def get_recieved_item(item) do
    Repo.one(from(d in Dispatch_Retailer, where: d.id == ^item, select: d.item))
  end

  def get_retailer_name(retailer) do
    Repo.one(from(d in User, where: d.id == ^retailer, select: d.company))
  end

  def get_retailer_owner(retailer) do
    Repo.one(
      from(
        d in User,
        where: d.id == ^retailer,
        select: fragment("concat(?, '  ', ?)", d.firstname, d.lastname)
      )
    )
  end

  def get_retailer_email(retailer) do
    Repo.one(from(d in User, where: d.id == ^retailer, select: d.email))
  end
end
