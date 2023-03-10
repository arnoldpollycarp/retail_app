defmodule ThamaniWeb.BalanceApiView do
  use ThamaniWeb, :view
  alias Thamani.Sales
  alias Thamani.Dispatches_Warehouse

  def render("index.json", %{validate: validate}) do
    %{data: render_one(validate, ThamaniWeb.ValidateApiView, "validate.json")}
  end

  def render("validate.json", %{validate_api: validate_api}) do
    %{}
  end
end
