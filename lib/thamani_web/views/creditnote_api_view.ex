defmodule ThamaniWeb.CreditnoteApiView do
  use ThamaniWeb, :view

  def render("index.json", %{notes: notes}) do
    %{data: render_many(notes, ThamaniWeb.CreditnoteApiView, "creditnote.json")}
  end

  def render("show.json", %{note: note}) do
    %{data: render_one(note, ThamaniWeb.CreditnoteApiView, "creditnote.json")}
  end

  def render("creditnote.json", %{creditnote_api: creditnote_api}) do
    %{
      uuid: creditnote_api.id,
      receipt_number: creditnote_api.receipt_number,
      item: creditnote_api.item,
      customer: creditnote_api.customer,
      phone: creditnote_api.phone,
      quantity: creditnote_api.quantity,
      notes: creditnote_api.description,
      active: creditnote_api.active
    }
  end
end
