defmodule Thamani.Reorders do
  @moduledoc """
  The Reorders context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Reorders.Reorder

  @doc """
  Returns the list of reorders.

  ## Examples

      iex> list_reorders()
      [%Reorder{}, ...]

  """
  def list_reorders do
    Repo.all(Reorder)
    |> Repo.preload(:sku)
    |> Repo.preload(:manufacturer)
    |> Repo.preload(:warehouse)
    |> Repo.preload(:user)
  end

  def list_recieved(warehouse) do
    Reorder

    Repo.all(from(d in Reorder, where: d.wid == ^warehouse and d.type == ^"warehouse"))
    |> Repo.preload(:sku)
    |> Repo.preload(:manufacturer)
    |> Repo.preload(:warehouse)
    |> Repo.preload(:user)
  end

  def list_recieved_man(manufacturer) do
    Reorder

    Repo.all(from(d in Reorder, where: d.mid == ^manufacturer and d.type == ^"manufacturer"))
    |> Repo.preload(:sku)
    |> Repo.preload(:manufacturer)
    |> Repo.preload(:warehouse)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single reorder.

  Raises `Ecto.NoResultsError` if the Reorder does not exist.

  ## Examples

      iex> get_reorder!(123)
      %Reorder{}

      iex> get_reorder!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reorder!(id) do
    Repo.get!(Reorder, id)
    |> Repo.preload(:sku)
    |> Repo.preload(:manufacturer)
    |> Repo.preload(:warehouse)
    |> Repo.preload(:user)
  end

  def get_recieved(warehouse, id) do
    Reorder

    Repo.one(
      from(d in Reorder, where: d.wid == ^warehouse and d.id == ^id and d.type == ^"warehouse")
    )
    |> Repo.preload(:sku)
    |> Repo.preload(:manufacturer)
    |> Repo.preload(:warehouse)
    |> Repo.preload(:user)
  end

  def get_recieved_man(manufacturer, id) do
    Reorder

    Repo.one(
      from(
        d in Reorder,
        where: d.mid == ^manufacturer and d.id == ^id and d.type == ^"manufacturer"
      )
    )
    |> Repo.preload(:sku)
    |> Repo.preload(:manufacturer)
    |> Repo.preload(:warehouse)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a reorder.

  ## Examples

      iex> create_reorder(%{field: value})
      {:ok, %Reorder{}}

      iex> create_reorder(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reorder(attrs \\ %{}) do
    %Reorder{}
    |> Reorder.changeset(attrs)
    |> Repo.insert()
  end

  def create_reorder_node(item, type, mid, wid, quantity, date, description, current_user) do
    %Reorder{
      item: item,
      type: type,
      mid: mid,
      wid: wid,
      quantity: quantity,
      date: date,
      description: description,
      user_id: current_user
    }
    |> Repo.insert()
  end

  @doc """
  Updates a reorder.

  ## Examples

      iex> update_reorder(reorder, %{field: new_value})
      {:ok, %Reorder{}}

      iex> update_reorder(reorder, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reorder(%Reorder{} = reorder, attrs) do
    reorder
    |> Reorder.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Reorder.

  ## Examples

      iex> delete_reorder(reorder)
      {:ok, %Reorder{}}

      iex> delete_reorder(reorder)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reorder(%Reorder{} = reorder) do
    Repo.delete(reorder)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reorder changes.

  ## Examples

      iex> change_reorder(reorder)
      %Ecto.Changeset{source: %Reorder{}}

  """
  def change_reorder(%Reorder{} = reorder) do
    Reorder.changeset(reorder, %{})
  end

  def check_reorder_today_item(item, date) do
    Repo.one(from(d in Reorder, where: d.item == ^item and d.date == ^date, select: count(d.id)))
  end
end
