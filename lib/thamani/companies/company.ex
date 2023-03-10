defmodule Thamani.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset
  alias Thamani.Companies.Company
  alias Thamani.Accounts.User

  schema "companies" do
    field(:active, :string)
    field(:description, :string)
    field(:name, :string)
    field(:category, :string)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(%Company{} = company, attrs) do
    company
    |> cast(attrs, [:name, :description, :category, :active])
    |> validate_required([:name, :description, :category, :active])
  end
end
