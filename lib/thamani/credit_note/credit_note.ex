defmodule Thamani.Credit_note do
  @moduledoc """
  The Credit_note context.
  """

  import Ecto.Query, warn: false
  alias Thamani.Repo

  alias Thamani.Credit_note.Notes

  @doc """
  Returns the list of note.

  ## Examples

      iex> list_note()
      [%Notes{}, ...]

  """
  def list_note do
    Repo.all(Notes)
  end

  def list_notes_by_user(user_id) do
    Repo.all(from(d in Notes, where: d.user_id == ^user_id))
  end

  @doc """
  Gets a single notes.

  Raises `Ecto.NoResultsError` if the Notes does not exist.

  ## Examples

      iex> get_notes!(123)
      %Notes{}

      iex> get_notes!(456)
      ** (Ecto.NoResultsError)

  """
  def get_notes!(id), do: Repo.get!(Notes, id)

  def get_note_by_user!(user_id, id) do
    Repo.one(from(d in Notes, where: d.user_id == ^user_id and d.id == ^id))
  end

  @doc """
  Creates a notes.

  ## Examples

      iex> create_notes(%{field: value})
      {:ok, %Notes{}}

      iex> create_notes(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_notes(attrs \\ %{}) do
    %Notes{}
    |> Notes.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a notes.

  ## Examples

      iex> update_notes(notes, %{field: new_value})
      {:ok, %Notes{}}

      iex> update_notes(notes, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_notes(%Notes{} = notes, attrs) do
    notes
    |> Notes.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Notes.

  ## Examples

      iex> delete_notes(notes)
      {:ok, %Notes{}}

      iex> delete_notes(notes)
      {:error, %Ecto.Changeset{}}

  """
  def delete_notes(%Notes{} = notes) do
    Repo.delete(notes)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking notes changes.

  ## Examples

      iex> change_notes(notes)
      %Ecto.Changeset{source: %Notes{}}

  """
  def change_notes(%Notes{} = notes) do
    Notes.changeset(notes, %{})
  end
end
