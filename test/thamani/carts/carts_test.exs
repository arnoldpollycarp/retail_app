defmodule Thamani.CartsTest do
  use Thamani.DataCase

  alias Thamani.Carts

  describe "carts" do
    alias Thamani.Carts.Cart

    @valid_attrs %{item: 42, qty: 42, status: "some status"}
    @update_attrs %{item: 43, qty: 43, status: "some updated status"}
    @invalid_attrs %{item: nil, qty: nil, status: nil}

    def cart_fixture(attrs \\ %{}) do
      {:ok, cart} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Carts.create_cart()

      cart
    end

    test "list_carts/0 returns all carts" do
      cart = cart_fixture()
      assert Carts.list_carts() == [cart]
    end

    test "get_cart!/1 returns the cart with given id" do
      cart = cart_fixture()
      assert Carts.get_cart!(cart.id) == cart
    end

    test "create_cart/1 with valid data creates a cart" do
      assert {:ok, %Cart{} = cart} = Carts.create_cart(@valid_attrs)
      assert cart.item == 42
      assert cart.qty == 42
      assert cart.status == "some status"
    end

    test "create_cart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Carts.create_cart(@invalid_attrs)
    end

    test "update_cart/2 with valid data updates the cart" do
      cart = cart_fixture()
      assert {:ok, cart} = Carts.update_cart(cart, @update_attrs)
      assert %Cart{} = cart
      assert cart.item == 43
      assert cart.qty == 43
      assert cart.status == "some updated status"
    end

    test "update_cart/2 with invalid data returns error changeset" do
      cart = cart_fixture()
      assert {:error, %Ecto.Changeset{}} = Carts.update_cart(cart, @invalid_attrs)
      assert cart == Carts.get_cart!(cart.id)
    end

    test "delete_cart/1 deletes the cart" do
      cart = cart_fixture()
      assert {:ok, %Cart{}} = Carts.delete_cart(cart)
      assert_raise Ecto.NoResultsError, fn -> Carts.get_cart!(cart.id) end
    end

    test "change_cart/1 returns a cart changeset" do
      cart = cart_fixture()
      assert %Ecto.Changeset{} = Carts.change_cart(cart)
    end
  end
end
