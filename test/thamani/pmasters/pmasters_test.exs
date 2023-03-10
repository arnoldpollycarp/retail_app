defmodule Thamani.PmastersTest do
  use Thamani.DataCase

  alias Thamani.Pmasters

  describe "pmaster" do
    alias Thamani.Pmasters.Pmaster

    @valid_attrs %{
      active: "some active",
      description: "some description",
      max: 42,
      min: 42,
      name: "some name"
    }
    @update_attrs %{
      active: "some updated active",
      description: "some updated description",
      max: 43,
      min: 43,
      name: "some updated name"
    }
    @invalid_attrs %{active: nil, description: nil, max: nil, min: nil, name: nil}

    def pmaster_fixture(attrs \\ %{}) do
      {:ok, pmaster} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Pmasters.create_pmaster()

      pmaster
    end

    test "list_pmaster/0 returns all pmaster" do
      pmaster = pmaster_fixture()
      assert Pmasters.list_pmaster() == [pmaster]
    end

    test "get_pmaster!/1 returns the pmaster with given id" do
      pmaster = pmaster_fixture()
      assert Pmasters.get_pmaster!(pmaster.id) == pmaster
    end

    test "create_pmaster/1 with valid data creates a pmaster" do
      assert {:ok, %Pmaster{} = pmaster} = Pmasters.create_pmaster(@valid_attrs)
      assert pmaster.active == "some active"
      assert pmaster.description == "some description"
      assert pmaster.max == 42
      assert pmaster.min == 42
      assert pmaster.name == "some name"
    end

    test "create_pmaster/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pmasters.create_pmaster(@invalid_attrs)
    end

    test "update_pmaster/2 with valid data updates the pmaster" do
      pmaster = pmaster_fixture()
      assert {:ok, pmaster} = Pmasters.update_pmaster(pmaster, @update_attrs)
      assert %Pmaster{} = pmaster
      assert pmaster.active == "some updated active"
      assert pmaster.description == "some updated description"
      assert pmaster.max == 43
      assert pmaster.min == 43
      assert pmaster.name == "some updated name"
    end

    test "update_pmaster/2 with invalid data returns error changeset" do
      pmaster = pmaster_fixture()
      assert {:error, %Ecto.Changeset{}} = Pmasters.update_pmaster(pmaster, @invalid_attrs)
      assert pmaster == Pmasters.get_pmaster!(pmaster.id)
    end

    test "delete_pmaster/1 deletes the pmaster" do
      pmaster = pmaster_fixture()
      assert {:ok, %Pmaster{}} = Pmasters.delete_pmaster(pmaster)
      assert_raise Ecto.NoResultsError, fn -> Pmasters.get_pmaster!(pmaster.id) end
    end

    test "change_pmaster/1 returns a pmaster changeset" do
      pmaster = pmaster_fixture()
      assert %Ecto.Changeset{} = Pmasters.change_pmaster(pmaster)
    end
  end

  describe "pmaster" do
    alias Thamani.Pmasters.Pmaster

    @valid_attrs %{
      active: "some active",
      description: "some description",
      max: 42,
      min: 42,
      name: "some name",
      type: "some type",
      user_id: "some user_id"
    }
    @update_attrs %{
      active: "some updated active",
      description: "some updated description",
      max: 43,
      min: 43,
      name: "some updated name",
      type: "some updated type",
      user_id: "some updated user_id"
    }
    @invalid_attrs %{
      active: nil,
      description: nil,
      max: nil,
      min: nil,
      name: nil,
      type: nil,
      user_id: nil
    }

    def pmaster_fixture(attrs \\ %{}) do
      {:ok, pmaster} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Pmasters.create_pmaster()

      pmaster
    end

    test "list_pmaster/0 returns all pmaster" do
      pmaster = pmaster_fixture()
      assert Pmasters.list_pmaster() == [pmaster]
    end

    test "get_pmaster!/1 returns the pmaster with given id" do
      pmaster = pmaster_fixture()
      assert Pmasters.get_pmaster!(pmaster.id) == pmaster
    end

    test "create_pmaster/1 with valid data creates a pmaster" do
      assert {:ok, %Pmaster{} = pmaster} = Pmasters.create_pmaster(@valid_attrs)
      assert pmaster.active == "some active"
      assert pmaster.description == "some description"
      assert pmaster.max == 42
      assert pmaster.min == 42
      assert pmaster.name == "some name"
      assert pmaster.type == "some type"
      assert pmaster.user_id == "some user_id"
    end

    test "create_pmaster/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pmasters.create_pmaster(@invalid_attrs)
    end

    test "update_pmaster/2 with valid data updates the pmaster" do
      pmaster = pmaster_fixture()
      assert {:ok, pmaster} = Pmasters.update_pmaster(pmaster, @update_attrs)
      assert %Pmaster{} = pmaster
      assert pmaster.active == "some updated active"
      assert pmaster.description == "some updated description"
      assert pmaster.max == 43
      assert pmaster.min == 43
      assert pmaster.name == "some updated name"
      assert pmaster.type == "some updated type"
      assert pmaster.user_id == "some updated user_id"
    end

    test "update_pmaster/2 with invalid data returns error changeset" do
      pmaster = pmaster_fixture()
      assert {:error, %Ecto.Changeset{}} = Pmasters.update_pmaster(pmaster, @invalid_attrs)
      assert pmaster == Pmasters.get_pmaster!(pmaster.id)
    end

    test "delete_pmaster/1 deletes the pmaster" do
      pmaster = pmaster_fixture()
      assert {:ok, %Pmaster{}} = Pmasters.delete_pmaster(pmaster)
      assert_raise Ecto.NoResultsError, fn -> Pmasters.get_pmaster!(pmaster.id) end
    end

    test "change_pmaster/1 returns a pmaster changeset" do
      pmaster = pmaster_fixture()
      assert %Ecto.Changeset{} = Pmasters.change_pmaster(pmaster)
    end
  end
end
