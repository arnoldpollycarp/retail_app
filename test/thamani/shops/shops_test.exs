defmodule Thamani.ShopsTest do
  use Thamani.DataCase

  alias Thamani.Shops

  describe "shop" do
    alias Thamani.Shops.Shop

    @valid_attrs %{
      active: "some active",
      description: "some description",
      location: "some location",
      name: "some name"
    }
    @update_attrs %{
      active: "some updated active",
      description: "some updated description",
      location: "some updated location",
      name: "some updated name"
    }
    @invalid_attrs %{active: nil, description: nil, location: nil, name: nil}

    def shop_fixture(attrs \\ %{}) do
      {:ok, shop} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Shops.create_shop()

      shop
    end

    test "list_shop/0 returns all shop" do
      shop = shop_fixture()
      assert Shops.list_shop() == [shop]
    end

    test "get_shop!/1 returns the shop with given id" do
      shop = shop_fixture()
      assert Shops.get_shop!(shop.id) == shop
    end

    test "create_shop/1 with valid data creates a shop" do
      assert {:ok, %Shop{} = shop} = Shops.create_shop(@valid_attrs)
      assert shop.active == "some active"
      assert shop.description == "some description"
      assert shop.location == "some location"
      assert shop.name == "some name"
    end

    test "create_shop/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shops.create_shop(@invalid_attrs)
    end

    test "update_shop/2 with valid data updates the shop" do
      shop = shop_fixture()
      assert {:ok, shop} = Shops.update_shop(shop, @update_attrs)
      assert %Shop{} = shop
      assert shop.active == "some updated active"
      assert shop.description == "some updated description"
      assert shop.location == "some updated location"
      assert shop.name == "some updated name"
    end

    test "update_shop/2 with invalid data returns error changeset" do
      shop = shop_fixture()
      assert {:error, %Ecto.Changeset{}} = Shops.update_shop(shop, @invalid_attrs)
      assert shop == Shops.get_shop!(shop.id)
    end

    test "delete_shop/1 deletes the shop" do
      shop = shop_fixture()
      assert {:ok, %Shop{}} = Shops.delete_shop(shop)
      assert_raise Ecto.NoResultsError, fn -> Shops.get_shop!(shop.id) end
    end

    test "change_shop/1 returns a shop changeset" do
      shop = shop_fixture()
      assert %Ecto.Changeset{} = Shops.change_shop(shop)
    end
  end
end
