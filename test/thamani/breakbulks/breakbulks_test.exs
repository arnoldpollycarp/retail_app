defmodule Thamani.BreakbulksTest do
  use Thamani.DataCase

  alias Thamani.Breakbulks

  describe "breakbulk" do
    alias Thamani.Breakbulks.Breakbulk

    @valid_attrs %{
      active: "some active",
      code: "some code",
      description: "some description",
      quantity: 42,
      scode: "some scode",
      user_id: "some user_id"
    }
    @update_attrs %{
      active: "some updated active",
      code: "some updated code",
      description: "some updated description",
      quantity: 43,
      scode: "some updated scode",
      user_id: "some updated user_id"
    }
    @invalid_attrs %{
      active: nil,
      code: nil,
      description: nil,
      quantity: nil,
      scode: nil,
      user_id: nil
    }

    def breakbulk_fixture(attrs \\ %{}) do
      {:ok, breakbulk} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Breakbulks.create_breakbulk()

      breakbulk
    end

    test "list_breakbulk/0 returns all breakbulk" do
      breakbulk = breakbulk_fixture()
      assert Breakbulks.list_breakbulk() == [breakbulk]
    end

    test "get_breakbulk!/1 returns the breakbulk with given id" do
      breakbulk = breakbulk_fixture()
      assert Breakbulks.get_breakbulk!(breakbulk.id) == breakbulk
    end

    test "create_breakbulk/1 with valid data creates a breakbulk" do
      assert {:ok, %Breakbulk{} = breakbulk} = Breakbulks.create_breakbulk(@valid_attrs)
      assert breakbulk.active == "some active"
      assert breakbulk.code == "some code"
      assert breakbulk.description == "some description"
      assert breakbulk.quantity == 42
      assert breakbulk.scode == "some scode"
      assert breakbulk.user_id == "some user_id"
    end

    test "create_breakbulk/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Breakbulks.create_breakbulk(@invalid_attrs)
    end

    test "update_breakbulk/2 with valid data updates the breakbulk" do
      breakbulk = breakbulk_fixture()
      assert {:ok, breakbulk} = Breakbulks.update_breakbulk(breakbulk, @update_attrs)
      assert %Breakbulk{} = breakbulk
      assert breakbulk.active == "some updated active"
      assert breakbulk.code == "some updated code"
      assert breakbulk.description == "some updated description"
      assert breakbulk.quantity == 43
      assert breakbulk.scode == "some updated scode"
      assert breakbulk.user_id == "some updated user_id"
    end

    test "update_breakbulk/2 with invalid data returns error changeset" do
      breakbulk = breakbulk_fixture()
      assert {:error, %Ecto.Changeset{}} = Breakbulks.update_breakbulk(breakbulk, @invalid_attrs)
      assert breakbulk == Breakbulks.get_breakbulk!(breakbulk.id)
    end

    test "delete_breakbulk/1 deletes the breakbulk" do
      breakbulk = breakbulk_fixture()
      assert {:ok, %Breakbulk{}} = Breakbulks.delete_breakbulk(breakbulk)
      assert_raise Ecto.NoResultsError, fn -> Breakbulks.get_breakbulk!(breakbulk.id) end
    end

    test "change_breakbulk/1 returns a breakbulk changeset" do
      breakbulk = breakbulk_fixture()
      assert %Ecto.Changeset{} = Breakbulks.change_breakbulk(breakbulk)
    end
  end

  describe "breakbulk" do
    alias Thamani.Breakbulks.Breakbulk

    @valid_attrs %{
      active: "some active",
      code: "some code",
      description: "some description",
      quantity: 42,
      scode: "some scode"
    }
    @update_attrs %{
      active: "some updated active",
      code: "some updated code",
      description: "some updated description",
      quantity: 43,
      scode: "some updated scode"
    }
    @invalid_attrs %{active: nil, code: nil, description: nil, quantity: nil, scode: nil}

    def breakbulk_fixture(attrs \\ %{}) do
      {:ok, breakbulk} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Breakbulks.create_breakbulk()

      breakbulk
    end

    test "list_breakbulk/0 returns all breakbulk" do
      breakbulk = breakbulk_fixture()
      assert Breakbulks.list_breakbulk() == [breakbulk]
    end

    test "get_breakbulk!/1 returns the breakbulk with given id" do
      breakbulk = breakbulk_fixture()
      assert Breakbulks.get_breakbulk!(breakbulk.id) == breakbulk
    end

    test "create_breakbulk/1 with valid data creates a breakbulk" do
      assert {:ok, %Breakbulk{} = breakbulk} = Breakbulks.create_breakbulk(@valid_attrs)
      assert breakbulk.active == "some active"
      assert breakbulk.code == "some code"
      assert breakbulk.description == "some description"
      assert breakbulk.quantity == 42
      assert breakbulk.scode == "some scode"
    end

    test "create_breakbulk/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Breakbulks.create_breakbulk(@invalid_attrs)
    end

    test "update_breakbulk/2 with valid data updates the breakbulk" do
      breakbulk = breakbulk_fixture()
      assert {:ok, breakbulk} = Breakbulks.update_breakbulk(breakbulk, @update_attrs)
      assert %Breakbulk{} = breakbulk
      assert breakbulk.active == "some updated active"
      assert breakbulk.code == "some updated code"
      assert breakbulk.description == "some updated description"
      assert breakbulk.quantity == 43
      assert breakbulk.scode == "some updated scode"
    end

    test "update_breakbulk/2 with invalid data returns error changeset" do
      breakbulk = breakbulk_fixture()
      assert {:error, %Ecto.Changeset{}} = Breakbulks.update_breakbulk(breakbulk, @invalid_attrs)
      assert breakbulk == Breakbulks.get_breakbulk!(breakbulk.id)
    end

    test "delete_breakbulk/1 deletes the breakbulk" do
      breakbulk = breakbulk_fixture()
      assert {:ok, %Breakbulk{}} = Breakbulks.delete_breakbulk(breakbulk)
      assert_raise Ecto.NoResultsError, fn -> Breakbulks.get_breakbulk!(breakbulk.id) end
    end

    test "change_breakbulk/1 returns a breakbulk changeset" do
      breakbulk = breakbulk_fixture()
      assert %Ecto.Changeset{} = Breakbulks.change_breakbulk(breakbulk)
    end
  end
end
