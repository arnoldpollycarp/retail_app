defmodule ThamaniWeb.MpesaApiView do
  use ThamaniWeb, :view
  alias Thamani.Sales
  alias Thamani.Dispatches_Warehouse

  def render("index.json", %{params: params}) do
    %{
      params: params
    }
  end

  def render("show.json", %{error: error}) do
    %{
      error: error
    }
  end

  def render("validate.json", %{validate_api: validate_api}) do
    %{}
  end
end
