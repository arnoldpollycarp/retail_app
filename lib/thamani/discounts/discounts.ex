defmodule Thamani.Discounts do
  @moduledoc """
  The Discounts context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Discounts.Discount

  @doc """
  Returns the list of discount.

  ## Examples

      iex> list_discount()
      [%Discount{}, ...]

  """
  def list_discount do
    Repo.all(Discount)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single discount.

  Raises `Ecto.NoResultsError` if the Discount does not exist.

  ## Examples

      iex> get_discount!(123)
      %Discount{}

      iex> get_discount!(456)
      ** (Ecto.NoResultsError)

  """
  def get_discount!(id) do
    Repo.get!(Discount, id)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a discount.

  ## Examples

      iex> create_discount(%{field: value})
      {:ok, %Discount{}}

      iex> create_discount(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_discount(attrs \\ %{}) do
    %Discount{}
    |> Discount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a discount.

  ## Examples

      iex> update_discount(discount, %{field: new_value})
      {:ok, %Discount{}}

      iex> update_discount(discount, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_discount(%Discount{} = discount, attrs) do
    discount
    |> Discount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Discount.

  ## Examples

      iex> delete_discount(discount)
      {:ok, %Discount{}}

      iex> delete_discount(discount)
      {:error, %Ecto.Changeset{}}

  """
  def delete_discount(%Discount{} = discount) do
    Repo.delete(discount)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking discount changes.

  ## Examples

      iex> change_discount(discount)
      %Ecto.Changeset{source: %Discount{}}

  """
  def change_discount(%Discount{} = discount) do
    Discount.changeset(discount, %{})
  end

  def get_items(current_user) do
    Repo.all(
      from(
        b in Discount,
        where: b.user_id == ^current_user.id or (b.user_id == ^"1" and b.active == ^"true"),
        select: {fragment("concat(?,  ' ( ' , ?, '% ) ')", b.name, b.value), b.id}
      )
    )
  end
end
