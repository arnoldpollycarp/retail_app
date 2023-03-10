defmodule Thamani.FloatsTest do
  use Thamani.DataCase

  alias Thamani.Floats

  describe "float" do
    alias Thamani.Floats.Float

    @valid_attrs %{
      account: 42,
      active: "some active",
      amount: 42,
      description: "some description",
      from: "some from",
      type: "some type",
      user_id: "some user_id"
    }
    @update_attrs %{
      account: 43,
      active: "some updated active",
      amount: 43,
      description: "some updated description",
      from: "some updated from",
      type: "some updated type",
      user_id: "some updated user_id"
    }
    @invalid_attrs %{
      account: nil,
      active: nil,
      amount: nil,
      description: nil,
      from: nil,
      type: nil,
      user_id: nil
    }

    def float_fixture(attrs \\ %{}) do
      {:ok, float} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Floats.create_float()

      float
    end

    test "list_float/0 returns all float" do
      float = float_fixture()
      assert Floats.list_float() == [float]
    end

    test "get_float!/1 returns the float with given id" do
      float = float_fixture()
      assert Floats.get_float!(float.id) == float
    end

    test "create_float/1 with valid data creates a float" do
      assert {:ok, %Float{} = float} = Floats.create_float(@valid_attrs)
      assert float.account == 42
      assert float.active == "some active"
      assert float.amount == 42
      assert float.description == "some description"
      assert float.from == "some from"
      assert float.type == "some type"
      assert float.user_id == "some user_id"
    end

    test "create_float/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Floats.create_float(@invalid_attrs)
    end

    test "update_float/2 with valid data updates the float" do
      float = float_fixture()
      assert {:ok, float} = Floats.update_float(float, @update_attrs)
      assert %Float{} = float
      assert float.account == 43
      assert float.active == "some updated active"
      assert float.amount == 43
      assert float.description == "some updated description"
      assert float.from == "some updated from"
      assert float.type == "some updated type"
      assert float.user_id == "some updated user_id"
    end

    test "update_float/2 with invalid data returns error changeset" do
      float = float_fixture()
      assert {:error, %Ecto.Changeset{}} = Floats.update_float(float, @invalid_attrs)
      assert float == Floats.get_float!(float.id)
    end

    test "delete_float/1 deletes the float" do
      float = float_fixture()
      assert {:ok, %Float{}} = Floats.delete_float(float)
      assert_raise Ecto.NoResultsError, fn -> Floats.get_float!(float.id) end
    end

    test "change_float/1 returns a float changeset" do
      float = float_fixture()
      assert %Ecto.Changeset{} = Floats.change_float(float)
    end
  end
end
