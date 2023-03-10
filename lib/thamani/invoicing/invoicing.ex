defmodule Thamani.Invoicing do
  @moduledoc """
  The Invoicing context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Invoicing.Invoice

  @doc """
  Returns the list of invoice.

  ## Examples

      iex> list_invoice()
      [%Invoice{}, ...]

  """
  def list_invoice(user_id) do
    Repo.all(from(d in Invoice, where: d.user_id == ^user_id and d.type == ^"manufacturer"))
  end

  def list_invoice_warehouse(user_id) do
    Repo.all(from(d in Invoice, where: d.user_id == ^user_id and d.type == ^"warehouse"))
  end

  def list_invoice_retail(user_id) do
    Repo.all(from(d in Invoice, where: d.user_id == ^user_id and d.type == ^"retail"))
  end

  @doc """
  Gets a single invoice.

  Raises `Ecto.NoResultsError` if the Invoice does not exist.

  ## Examples

      iex> get_invoice!(123)
      %Invoice{}

      iex> get_invoice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invoice!(id), do: Repo.get!(Invoice, id)

  @doc """
  Creates a invoice.

  ## Examples

      iex> create_invoice(%{field: value})
      {:ok, %Invoice{}}

      iex> create_invoice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invoice(attrs \\ %{}) do
    %Invoice{}
    |> Invoice.changeset(attrs)
    |> Repo.insert()
  end

  def create_invoice_node(invoice_number, items, current_user) do
    %Invoice{
      invoice_number: invoice_number,
      type: "manufacturer",
      items: items,
      active: "true",
      user_id: current_user
    }
    |> Repo.insert()
  end

  def create_invoice_warehouse_node(invoice_number, items, current_user) do
    %Invoice{
      invoice_number: invoice_number,
      type: "warehouse",
      items: items,
      active: "true",
      user_id: current_user
    }
    |> Repo.insert()
  end

  def create_invoice_retail_node(invoice_number, items, current_user) do
    %Invoice{
      invoice_number: invoice_number,
      type: "retail",
      items: items,
      active: "true",
      user_id: current_user
    }
    |> Repo.insert()
  end

  @doc """
  Updates a invoice.

  ## Examples

      iex> update_invoice(invoice, %{field: new_value})
      {:ok, %Invoice{}}

      iex> update_invoice(invoice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invoice(%Invoice{} = invoice, attrs) do
    invoice
    |> Invoice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Invoice.

  ## Examples

      iex> delete_invoice(invoice)
      {:ok, %Invoice{}}

      iex> delete_invoice(invoice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invoice(%Invoice{} = invoice) do
    Repo.delete(invoice)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invoice changes.

  ## Examples

      iex> change_invoice(invoice)
      %Ecto.Changeset{source: %Invoice{}}

  """
  def change_invoice(%Invoice{} = invoice) do
    Invoice.changeset(invoice, %{})
  end

  def get_last_id() do
    Repo.one(from(d in Invoice, select: max(d.id)))
  end
end
