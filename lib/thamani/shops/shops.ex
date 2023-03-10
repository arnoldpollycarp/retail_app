defmodule Thamani.Shops do
  @moduledoc """
  The Shops context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Shops.Shop
  alias Thamani.Kcitys.KCity

  @doc """
  Returns the list of shop.

  ## Examples

      iex> list_shop()
      [%Shop{}, ...]

  """
  def list_shop do
    Repo.all(Shop)
    |> Repo.preload(:kcity)
    |> Repo.preload(:user)
  end

  def list_shop!(current_user) do
    Repo.all(from(d in Shop, where: d.user_id == ^current_user.id, select: {d.name, d.id}))
  end

  @doc """
  Gets a single shop.

  Raises `Ecto.NoResultsError` if the Shop does not exist.

  ## Examples

      iex> get_shop!(123)
      %Shop{}

      iex> get_shop!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shop!(id) do
    Repo.get!(Shop, id)
    |> Repo.preload(:kcity)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a shop.

  ## Examples

      iex> create_shop(%{field: value})
      {:ok, %Shop{}}

      iex> create_shop(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shop(attrs \\ %{}) do
    %Shop{}
    |> Shop.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shop.

  ## Examples

      iex> update_shop(shop, %{field: new_value})
      {:ok, %Shop{}}

      iex> update_shop(shop, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shop(%Shop{} = shop, attrs) do
    shop
    |> Shop.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Shop.

  ## Examples

      iex> delete_shop(shop)
      {:ok, %Shop{}}

      iex> delete_shop(shop)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shop(%Shop{} = shop) do
    Repo.delete(shop)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shop changes.

  ## Examples

      iex> change_shop(shop)
      %Ecto.Changeset{source: %Shop{}}

  """
  def change_shop(%Shop{} = shop) do
    Shop.changeset(shop, %{})
  end

  def get_city() do
    Repo.all(
      from(
        b in KCity,
        select: {fragment("concat(?, ' ( ', ?,' county ) ')", b.city, b.county), b.id}
      )
    )
  end
end
