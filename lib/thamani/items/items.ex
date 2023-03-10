defmodule Thamani.Items do
  @moduledoc """
  The Items context.
  """
  import Ecto.Query, warn: false
  alias Thamani.Repo
  alias Thamani.Items.Sku
  alias Thamani.GTIN.Barcode
  alias Thamani.Accounts.User
  use Rummage.Ecto
  use Arc.Ecto.Schema

  @doc """
  Returns the list of sku.

  ## Examples

      iex> list_sku()
      [%Sku{}, ...]

  """
  def list_sku() do
    Sku
    |> Repo.all()
    |> Repo.preload(:user)
    |> Repo.preload(:pmaster)
  end

  def list_sku_items() do
    Sku
    Repo.all(from(d in Sku, distinct: true, select: d.user_id))
  end

  def list_sku_user(user) do
    Repo.all(from(d in Sku, where: d.user_id == ^user))
    |> Repo.preload(:user)
    |> Repo.preload(:pmaster)
  end

  def list_sku_name(text, text2) do
    Repo.all(from(b in Barcode, where: b.code == ^text and b.mn == ^text2, select: [b.name]))
  end

  def list_sku_name!(text) do
    Repo.all(from(b in Sku, where: b.id == ^text, select: [b.name]))
  end

  def list_sku_gtin(text, text2) do
    Repo.all(from(b in Barcode, where: b.code == ^text and b.mn == ^text2, select: [b.code]))
  end

  def list_sku_description(text, text2) do
    Repo.all(
      from(b in Barcode, where: b.code == ^text and b.mn == ^text2, select: [b.description])
    )
  end

  @doc """
  Gets a single sku.

  Raises `Ecto.NoResultsError` if the Sku does not exist.

  ## Examples

      iex> get_sku!(123)
      %Sku{}

      iex> get_sku!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sku!(id) do
    Sku
    |> Repo.get!(id)
    |> Repo.preload(:pmaster)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a sku.

  ## Examples

      iex> create_sku(%{field: value})
      {:ok, %Sku{}}

      iex> create_sku(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sku(attrs \\ %{}) do
    %Sku{}
    |> Sku.changeset(attrs)
    |> Repo.insert()
  end

  def create_sku_node(
        name,
        code,
        text,
        price,
        delivery,
        weight,
        scode,
        weight2,
        width,
        length,
        height,
        quantity,
        quantity_unit,
        min_quantity,
        category,
        image,
        active,
        current_user
      ) do
    %Sku{
      name: name,
      gtin: code,
      description: text,
      price: price,
      delivery: delivery,
      weight: weight,
      scode: scode,
      weight2: weight2,
      width: width,
      length: length,
      height: height,
      quantity: quantity,
      quantity_unit: quantity_unit,
      min_quantity: min_quantity,
      category: category,
      active: active,
      user_id: current_user
    }
    |> Repo.insert()
  end

  @doc """
  Updates a sku.

  ## Examples

      iex> update_sku(sku, %{field: new_value})
      {:ok, %Sku{}}

      iex> update_sku(sku, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sku(%Sku{} = sku, attrs) do
    sku
    |> Sku.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Sku.

  ## Examples

      iex> delete_sku(sku)
      {:ok, %Sku{}}

      iex> delete_sku(sku)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sku(%Sku{} = sku) do
    Repo.delete(sku)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sku changes.

  ## Examples

      iex> change_sku(sku)
      %Ecto.Changeset{source: %Sku{}}

  """
  def change_sku(%Sku{} = sku) do
    Sku.changeset(sku, %{})
  end

  def get_count_sku(current_user) do
    Repo.one(
      from(
        u in Sku,
        where: u.user_id == ^current_user.id and u.active == ^"true",
        select: count(u.id)
      )
    )
  end

  def get_countall_sku() do
    Repo.one(from(u in Sku, select: count(u.id)))
  end

  def get_items(current_user) do
    Repo.all(
      from(
        b in Sku,
        where: b.user_id == ^current_user.id and b.active == ^"true",
        select: {fragment("concat(?, ' ( ', ?,' ) ' )", b.gtin, b.name), b.id}
      )
    )
  end

  def get_items_datalist(current_user) do
    Repo.all(
      from(
        b in Sku,
        where: b.user_id == ^current_user.id and b.active == ^"true",
        order_by: [desc: b.id]
      )
    )
  end

  def check_item(code) do
    Repo.one(from(d in Sku, where: d.gtin == ^code, select: count(d.id)))
  end

  def check_min_quantity(item) do
    Repo.one(from(d in Sku, where: d.id == ^item, select: d.min_quantity))
  end

  def check_item_man(code, current_user) do
    Repo.one(
      from(d in Sku, where: d.gtin == ^code and d.user_id == ^current_user, select: count(d.id))
    )
  end

  def get_image(item) do
    Repo.one(from(s in Sku, where: s.id == ^item, select: s.image))
  end

  def get_manufacturer_name(manufacturer) do
    Repo.one(from(d in User, where: d.id == ^manufacturer, select: d.company))
  end

  def get_manufacturer_items(manufacturer) do
    Repo.one(from(d in Sku, where: d.user_id == ^manufacturer, select: count(d.id)))
  end
end
