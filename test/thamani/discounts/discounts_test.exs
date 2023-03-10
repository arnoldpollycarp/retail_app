defmodule Thamani.DiscountsTest do
  use Thamani.DataCase

  alias Thamani.Discounts

  describe "discount" do
    alias Thamani.Discounts.Discount

    @valid_attrs %{
      active: "some active",
      description: "some description",
      name: "some name",
      value: 42
    }
    @update_attrs %{
      active: "some updated active",
      description: "some updated description",
      name: "some updated name",
      value: 43
    }
    @invalid_attrs %{active: nil, description: nil, name: nil, value: nil}

    def discount_fixture(attrs \\ %{}) do
      {:ok, discount} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Discounts.create_discount()

      discount
    end

    test "list_discount/0 returns all discount" do
      discount = discount_fixture()
      assert Discounts.list_discount() == [discount]
    end

    test "get_discount!/1 returns the discount with given id" do
      discount = discount_fixture()
      assert Discounts.get_discount!(discount.id) == discount
    end

    test "create_discount/1 with valid data creates a discount" do
      assert {:ok, %Discount{} = discount} = Discounts.create_discount(@valid_attrs)
      assert discount.active == "some active"
      assert discount.description == "some description"
      assert discount.name == "some name"
      assert discount.value == 42
    end

    test "create_discount/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Discounts.create_discount(@invalid_attrs)
    end

    test "update_discount/2 with valid data updates the discount" do
      discount = discount_fixture()
      assert {:ok, discount} = Discounts.update_discount(discount, @update_attrs)
      assert %Discount{} = discount
      assert discount.active == "some updated active"
      assert discount.description == "some updated description"
      assert discount.name == "some updated name"
      assert discount.value == 43
    end

    test "update_discount/2 with invalid data returns error changeset" do
      discount = discount_fixture()
      assert {:error, %Ecto.Changeset{}} = Discounts.update_discount(discount, @invalid_attrs)
      assert discount == Discounts.get_discount!(discount.id)
    end

    test "delete_discount/1 deletes the discount" do
      discount = discount_fixture()
      assert {:ok, %Discount{}} = Discounts.delete_discount(discount)
      assert_raise Ecto.NoResultsError, fn -> Discounts.get_discount!(discount.id) end
    end

    test "change_discount/1 returns a discount changeset" do
      discount = discount_fixture()
      assert %Ecto.Changeset{} = Discounts.change_discount(discount)
    end
  end
end
