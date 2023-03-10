defmodule Thamani.DevicesTest do
  use Thamani.DataCase

  alias Thamani.Devices

  describe "device" do
    alias Thamani.Devices.Device

    @valid_attrs %{
      active: "some active",
      description: "some description",
      imei: "some imei",
      name: "some name"
    }
    @update_attrs %{
      active: "some updated active",
      description: "some updated description",
      imei: "some updated imei",
      name: "some updated name"
    }
    @invalid_attrs %{active: nil, description: nil, imei: nil, name: nil}

    def device_fixture(attrs \\ %{}) do
      {:ok, device} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Devices.create_device()

      device
    end

    test "list_device/0 returns all device" do
      device = device_fixture()
      assert Devices.list_device() == [device]
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert Devices.get_device!(device.id) == device
    end

    test "create_device/1 with valid data creates a device" do
      assert {:ok, %Device{} = device} = Devices.create_device(@valid_attrs)
      assert device.active == "some active"
      assert device.description == "some description"
      assert device.imei == "some imei"
      assert device.name == "some name"
    end

    test "create_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Devices.create_device(@invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      assert {:ok, device} = Devices.update_device(device, @update_attrs)
      assert %Device{} = device
      assert device.active == "some updated active"
      assert device.description == "some updated description"
      assert device.imei == "some updated imei"
      assert device.name == "some updated name"
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = Devices.update_device(device, @invalid_attrs)
      assert device == Devices.get_device!(device.id)
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = Devices.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> Devices.get_device!(device.id) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = Devices.change_device(device)
    end
  end
end
