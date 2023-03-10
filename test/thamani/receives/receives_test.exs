defmodule Thamani.ReceivesTest do
  use Thamani.DataCase

  alias Thamani.Receives

  describe "received" do
    alias Thamani.Receives.Received

    @valid_attrs %{breakbulk_id: 42, item: 42, quantity: 42, scode: 42, warehouse: 42}
    @update_attrs %{breakbulk_id: 43, item: 43, quantity: 43, scode: 43, warehouse: 43}
    @invalid_attrs %{breakbulk_id: nil, item: nil, quantity: nil, scode: nil, warehouse: nil}

    def received_fixture(attrs \\ %{}) do
      {:ok, received} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Receives.create_received()

      received
    end

    test "list_received/0 returns all received" do
      received = received_fixture()
      assert Receives.list_received() == [received]
    end

    test "get_received!/1 returns the received with given id" do
      received = received_fixture()
      assert Receives.get_received!(received.id) == received
    end

    test "create_received/1 with valid data creates a received" do
      assert {:ok, %Received{} = received} = Receives.create_received(@valid_attrs)
      assert received.breakbulk_id == 42
      assert received.item == 42
      assert received.quantity == 42
      assert received.scode == 42
      assert received.warehouse == 42
    end

    test "create_received/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Receives.create_received(@invalid_attrs)
    end

    test "update_received/2 with valid data updates the received" do
      received = received_fixture()
      assert {:ok, received} = Receives.update_received(received, @update_attrs)
      assert %Received{} = received
      assert received.breakbulk_id == 43
      assert received.item == 43
      assert received.quantity == 43
      assert received.scode == 43
      assert received.warehouse == 43
    end

    test "update_received/2 with invalid data returns error changeset" do
      received = received_fixture()
      assert {:error, %Ecto.Changeset{}} = Receives.update_received(received, @invalid_attrs)
      assert received == Receives.get_received!(received.id)
    end

    test "delete_received/1 deletes the received" do
      received = received_fixture()
      assert {:ok, %Received{}} = Receives.delete_received(received)
      assert_raise Ecto.NoResultsError, fn -> Receives.get_received!(received.id) end
    end

    test "change_received/1 returns a received changeset" do
      received = received_fixture()
      assert %Ecto.Changeset{} = Receives.change_received(received)
    end
  end
end
