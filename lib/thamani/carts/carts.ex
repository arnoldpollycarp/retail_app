defmodule Thamani.Carts do
  @moduledoc """
  The Carts context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Carts.Cart
  alias Thamani.Items.Sku

  @doc """
  Returns the list of carts.

  ## Examples

      iex> list_carts()
      [%Cart{}, ...]

  """
  def list_carts do
    Repo.all(Cart)
  end

  @doc """
  Gets a single cart.

  Raises `Ecto.NoResultsError` if the Cart does not exist.

  ## Examples

      iex> get_cart!(123)
      %Cart{}

      iex> get_cart!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cart!(id), do: Repo.get!(Cart, id)

  def get_cart_user(user,id) do

      Repo.one(from(d in Cart, where: d.user_id == ^user and d.item ==^id and d.status ==^"active",select: (d.id) ))

    end

    def get_cart_user!(user) do

        Repo.all(from(d in Cart, where: d.user_id == ^user and d.status ==^"active", preload: [:sku] ))

      end

      def get_cart_user_id!(user) do

            Repo.all(from(d in Cart, where: d.user_id == ^user and d.status ==^"active", select: d.id ))

       end

    def get_cart_user_item!(user) do

          Repo.all(from(d in Cart, where: d.user_id == ^user and d.status ==^"active", select: d.item ))

     end
    def get_cart_user_qty!(user) do

            Repo.all(from(d in Cart, where: d.user_id == ^user and d.status ==^"active", select: d.qty ))

      end
      def get_cart_user_cat!(user) do

              Repo.all(from(d in Cart,join: c in Sku, where: d.item == c.id and d.user_id == ^user and d.status ==^"active", select: c.category ))

        end
      def get_cart_total!(user) do

          Repo.one(
          from(
          d in Cart,
          join: c in Sku,
          where: d.item == c.id and d.user_id == ^user and d.status ==^"active" ,
          select: fragment("sum((s1.`price` + s1.`markup`) * c0.`qty`)")))

        end



  def get_count_carts(user) do
    Repo.one(from(d in Cart, where: d.user_id == ^user and d.status ==^"active",select: count(d.id)))
  end

  @doc """
  Creates a cart.

  ## Examples

      iex> create_cart(%{field: value})
      {:ok, %Cart{}}

      iex> create_cart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cart(attrs \\ %{}) do
    %Cart{}
    |> Cart.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cart.

  ## Examples

      iex> update_cart(cart, %{field: new_value})
      {:ok, %Cart{}}

      iex> update_cart(cart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cart(%Cart{} = cart, attrs) do
    cart
    |> Cart.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Cart.

  ## Examples

      iex> delete_cart(cart)
      {:ok, %Cart{}}

      iex> delete_cart(cart)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cart(%Cart{} = cart) do
    Repo.delete(cart)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart changes.

  ## Examples

      iex> change_cart(cart)
      %Ecto.Changeset{source: %Cart{}}

  """
  def change_cart(%Cart{} = cart) do
    Cart.changeset(cart, %{})
  end
end
