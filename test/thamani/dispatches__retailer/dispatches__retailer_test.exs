defmodule Thamani.Dispatches_RetailerTest do
  use Thamani.DataCase

  alias Thamani.Dispatches_Retailer

  describe "dispatches_retailer" do
    alias Thamani.Dispatches_Retailer.Dispatch_Retailer

    @valid_attrs %{
      active: "some active",
      description: "some description",
      item: 42,
      quantity: 42,
      retailer: 42,
      total: 42,
      transporter: "some transporter",
      transporterid: "some transporterid"
    }
    @update_attrs %{
      active: "some updated active",
      description: "some updated description",
      item: 43,
      quantity: 43,
      retailer: 43,
      total: 43,
      transporter: "some updated transporter",
      transporterid: "some updated transporterid"
    }
    @invalid_attrs %{
      active: nil,
      description: nil,
      item: nil,
      quantity: nil,
      retailer: nil,
      total: nil,
      transporter: nil,
      transporterid: nil
    }

    def dispatch__retailer_fixture(attrs \\ %{}) do
      {:ok, dispatch__retailer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Dispatches_Retailer.create_dispatch__retailer()

      dispatch__retailer
    end

    test "list_dispatches_retailer/0 returns all dispatches_retailer" do
      dispatch__retailer = dispatch__retailer_fixture()
      assert Dispatches_Retailer.list_dispatches_retailer() == [dispatch__retailer]
    end

    test "get_dispatch__retailer!/1 returns the dispatch__retailer with given id" do
      dispatch__retailer = dispatch__retailer_fixture()

      assert Dispatches_Retailer.get_dispatch__retailer!(dispatch__retailer.id) ==
               dispatch__retailer
    end

    test "create_dispatch__retailer/1 with valid data creates a dispatch__retailer" do
      assert {:ok, %Dispatch_Retailer{} = dispatch__retailer} =
               Dispatches_Retailer.create_dispatch__retailer(@valid_attrs)

      assert dispatch__retailer.active == "some active"
      assert dispatch__retailer.description == "some description"
      assert dispatch__retailer.item == 42
      assert dispatch__retailer.quantity == 42
      assert dispatch__retailer.retailer == 42
      assert dispatch__retailer.total == 42
      assert dispatch__retailer.transporter == "some transporter"
      assert dispatch__retailer.transporterid == "some transporterid"
    end

    test "create_dispatch__retailer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Dispatches_Retailer.create_dispatch__retailer(@invalid_attrs)
    end

    test "update_dispatch__retailer/2 with valid data updates the dispatch__retailer" do
      dispatch__retailer = dispatch__retailer_fixture()

      assert {:ok, dispatch__retailer} =
               Dispatches_Retailer.update_dispatch__retailer(dispatch__retailer, @update_attrs)

      assert %Dispatch_Retailer{} = dispatch__retailer
      assert dispatch__retailer.active == "some updated active"
      assert dispatch__retailer.description == "some updated description"
      assert dispatch__retailer.item == 43
      assert dispatch__retailer.quantity == 43
      assert dispatch__retailer.retailer == 43
      assert dispatch__retailer.total == 43
      assert dispatch__retailer.transporter == "some updated transporter"
      assert dispatch__retailer.transporterid == "some updated transporterid"
    end

    test "update_dispatch__retailer/2 with invalid data returns error changeset" do
      dispatch__retailer = dispatch__retailer_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Dispatches_Retailer.update_dispatch__retailer(dispatch__retailer, @invalid_attrs)

      assert dispatch__retailer ==
               Dispatches_Retailer.get_dispatch__retailer!(dispatch__retailer.id)
    end

    test "delete_dispatch__retailer/1 deletes the dispatch__retailer" do
      dispatch__retailer = dispatch__retailer_fixture()

      assert {:ok, %Dispatch_Retailer{}} =
               Dispatches_Retailer.delete_dispatch__retailer(dispatch__retailer)

      assert_raise Ecto.NoResultsError, fn ->
        Dispatches_Retailer.get_dispatch__retailer!(dispatch__retailer.id)
      end
    end

    test "change_dispatch__retailer/1 returns a dispatch__retailer changeset" do
      dispatch__retailer = dispatch__retailer_fixture()
      assert %Ecto.Changeset{} = Dispatches_Retailer.change_dispatch__retailer(dispatch__retailer)
    end
  end
end
