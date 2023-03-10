defmodule Thamani.InvoicingTest do
  use Thamani.DataCase

  alias Thamani.Invoicing

  describe "invoice" do
    alias Thamani.Invoicing.Invoice

    @valid_attrs %{
      active: "some active",
      invoice_number: "some invoice_number",
      items: 42,
      type: "some type"
    }
    @update_attrs %{
      active: "some updated active",
      invoice_number: "some updated invoice_number",
      items: 43,
      type: "some updated type"
    }
    @invalid_attrs %{active: nil, invoice_number: nil, items: nil, type: nil}

    def invoice_fixture(attrs \\ %{}) do
      {:ok, invoice} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Invoicing.create_invoice()

      invoice
    end

    test "list_invoice/0 returns all invoice" do
      invoice = invoice_fixture()
      assert Invoicing.list_invoice() == [invoice]
    end

    test "get_invoice!/1 returns the invoice with given id" do
      invoice = invoice_fixture()
      assert Invoicing.get_invoice!(invoice.id) == invoice
    end

    test "create_invoice/1 with valid data creates a invoice" do
      assert {:ok, %Invoice{} = invoice} = Invoicing.create_invoice(@valid_attrs)
      assert invoice.active == "some active"
      assert invoice.invoice_number == "some invoice_number"
      assert invoice.items == 42
      assert invoice.type == "some type"
    end

    test "create_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Invoicing.create_invoice(@invalid_attrs)
    end

    test "update_invoice/2 with valid data updates the invoice" do
      invoice = invoice_fixture()
      assert {:ok, invoice} = Invoicing.update_invoice(invoice, @update_attrs)
      assert %Invoice{} = invoice
      assert invoice.active == "some updated active"
      assert invoice.invoice_number == "some updated invoice_number"
      assert invoice.items == 43
      assert invoice.type == "some updated type"
    end

    test "update_invoice/2 with invalid data returns error changeset" do
      invoice = invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Invoicing.update_invoice(invoice, @invalid_attrs)
      assert invoice == Invoicing.get_invoice!(invoice.id)
    end

    test "delete_invoice/1 deletes the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{}} = Invoicing.delete_invoice(invoice)
      assert_raise Ecto.NoResultsError, fn -> Invoicing.get_invoice!(invoice.id) end
    end

    test "change_invoice/1 returns a invoice changeset" do
      invoice = invoice_fixture()
      assert %Ecto.Changeset{} = Invoicing.change_invoice(invoice)
    end
  end
end
