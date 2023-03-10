defmodule Thamani.Retman_ordersTest do
  use Thamani.DataCase

  alias Thamani.Retman_orders

  describe "retman_orders" do
    alias Thamani.Retman_orders.Retman_order

    @valid_attrs %{
      active: "some active",
      category: "some category",
      description: "some description",
      item: 42,
      manufacturer: 42,
      quantity: 42,
      uom: "some uom"
    }
    @update_attrs %{
      active: "some updated active",
      category: "some updated category",
      description: "some updated description",
      item: 43,
      manufacturer: 43,
      quantity: 43,
      uom: "some updated uom"
    }
    @invalid_attrs %{
      active: nil,
      category: nil,
      description: nil,
      item: nil,
      manufacturer: nil,
      quantity: nil,
      uom: nil
    }

    def retman_order_fixture(attrs \\ %{}) do
      {:ok, retman_order} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Retman_orders.create_retman_order()

      retman_order
    end

    test "list_retman_orders/0 returns all retman_orders" do
      retman_order = retman_order_fixture()
      assert Retman_orders.list_retman_orders() == [retman_order]
    end

    test "get_retman_order!/1 returns the retman_order with given id" do
      retman_order = retman_order_fixture()
      assert Retman_orders.get_retman_order!(retman_order.id) == retman_order
    end

    test "create_retman_order/1 with valid data creates a retman_order" do
      assert {:ok, %Retman_order{} = retman_order} =
               Retman_orders.create_retman_order(@valid_attrs)

      assert retman_order.active == "some active"
      assert retman_order.category == "some category"
      assert retman_order.description == "some description"
      assert retman_order.item == 42
      assert retman_order.manufacturer == 42
      assert retman_order.quantity == 42
      assert retman_order.uom == "some uom"
    end

    test "create_retman_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Retman_orders.create_retman_order(@invalid_attrs)
    end

    test "update_retman_order/2 with valid data updates the retman_order" do
      retman_order = retman_order_fixture()
      assert {:ok, retman_order} = Retman_orders.update_retman_order(retman_order, @update_attrs)
      assert %Retman_order{} = retman_order
      assert retman_order.active == "some updated active"
      assert retman_order.category == "some updated category"
      assert retman_order.description == "some updated description"
      assert retman_order.item == 43
      assert retman_order.manufacturer == 43
      assert retman_order.quantity == 43
      assert retman_order.uom == "some updated uom"
    end

    test "update_retman_order/2 with invalid data returns error changeset" do
      retman_order = retman_order_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Retman_orders.update_retman_order(retman_order, @invalid_attrs)

      assert retman_order == Retman_orders.get_retman_order!(retman_order.id)
    end

    test "delete_retman_order/1 deletes the retman_order" do
      retman_order = retman_order_fixture()
      assert {:ok, %Retman_order{}} = Retman_orders.delete_retman_order(retman_order)
      assert_raise Ecto.NoResultsError, fn -> Retman_orders.get_retman_order!(retman_order.id) end
    end

    test "change_retman_order/1 returns a retman_order changeset" do
      retman_order = retman_order_fixture()
      assert %Ecto.Changeset{} = Retman_orders.change_retman_order(retman_order)
    end
  end
end
