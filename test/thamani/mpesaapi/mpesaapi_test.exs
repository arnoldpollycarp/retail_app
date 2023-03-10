defmodule Thamani.MpesaapiTest do
  use Thamani.DataCase

  alias Thamani.Mpesaapi

  describe "mpesa" do
    alias Thamani.Mpesaapi.Mpesa

    @valid_attrs %{
      amount: 42,
      description: "some description",
      phone: 42,
      receipt: "some receipt",
      transactiondate: "some transactiondate"
    }
    @update_attrs %{
      amount: 43,
      description: "some updated description",
      phone: 43,
      receipt: "some updated receipt",
      transactiondate: "some updated transactiondate"
    }
    @invalid_attrs %{
      amount: nil,
      description: nil,
      phone: nil,
      receipt: nil,
      transactiondate: nil
    }

    def mpesa_fixture(attrs \\ %{}) do
      {:ok, mpesa} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Mpesaapi.create_mpesa()

      mpesa
    end

    test "list_mpesa/0 returns all mpesa" do
      mpesa = mpesa_fixture()
      assert Mpesaapi.list_mpesa() == [mpesa]
    end

    test "get_mpesa!/1 returns the mpesa with given id" do
      mpesa = mpesa_fixture()
      assert Mpesaapi.get_mpesa!(mpesa.id) == mpesa
    end

    test "create_mpesa/1 with valid data creates a mpesa" do
      assert {:ok, %Mpesa{} = mpesa} = Mpesaapi.create_mpesa(@valid_attrs)
      assert mpesa.amount == 42
      assert mpesa.description == "some description"
      assert mpesa.phone == 42
      assert mpesa.receipt == "some receipt"
      assert mpesa.transactiondate == "some transactiondate"
    end

    test "create_mpesa/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mpesaapi.create_mpesa(@invalid_attrs)
    end

    test "update_mpesa/2 with valid data updates the mpesa" do
      mpesa = mpesa_fixture()
      assert {:ok, mpesa} = Mpesaapi.update_mpesa(mpesa, @update_attrs)
      assert %Mpesa{} = mpesa
      assert mpesa.amount == 43
      assert mpesa.description == "some updated description"
      assert mpesa.phone == 43
      assert mpesa.receipt == "some updated receipt"
      assert mpesa.transactiondate == "some updated transactiondate"
    end

    test "update_mpesa/2 with invalid data returns error changeset" do
      mpesa = mpesa_fixture()
      assert {:error, %Ecto.Changeset{}} = Mpesaapi.update_mpesa(mpesa, @invalid_attrs)
      assert mpesa == Mpesaapi.get_mpesa!(mpesa.id)
    end

    test "delete_mpesa/1 deletes the mpesa" do
      mpesa = mpesa_fixture()
      assert {:ok, %Mpesa{}} = Mpesaapi.delete_mpesa(mpesa)
      assert_raise Ecto.NoResultsError, fn -> Mpesaapi.get_mpesa!(mpesa.id) end
    end

    test "change_mpesa/1 returns a mpesa changeset" do
      mpesa = mpesa_fixture()
      assert %Ecto.Changeset{} = Mpesaapi.change_mpesa(mpesa)
    end
  end
end
