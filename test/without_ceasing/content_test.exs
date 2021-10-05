defmodule WithoutCeasing.ContentTest do
  use WithoutCeasing.DataCase

  alias WithoutCeasing.Content

  describe "resources" do
    alias WithoutCeasing.Content.Resource

    import WithoutCeasing.ContentFixtures

    @invalid_attrs %{description: nil, status: nil, title: nil}

    test "list_resources/0 returns all resources" do
      resource = resource_fixture()
      assert Content.list_resources() == [resource]
    end

    test "get_resource!/1 returns the resource with given id" do
      resource = resource_fixture()
      assert Content.get_resource!(resource.id) == resource
    end

    test "create_resource/1 with valid data creates a resource" do
      valid_attrs = %{description: "some description", status: :pending, title: "some title"}

      assert {:ok, %Resource{} = resource} = Content.create_resource(valid_attrs)
      assert resource.description == "some description"
      assert resource.status == :pending
      assert resource.title == "some title"
    end

    test "create_resource/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_resource(@invalid_attrs)
    end

    test "update_resource/2 with valid data updates the resource" do
      resource = resource_fixture()
      update_attrs = %{description: "some updated description", status: :approved, title: "some updated title"}

      assert {:ok, %Resource{} = resource} = Content.update_resource(resource, update_attrs)
      assert resource.description == "some updated description"
      assert resource.status == :approved
      assert resource.title == "some updated title"
    end

    test "update_resource/2 with invalid data returns error changeset" do
      resource = resource_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_resource(resource, @invalid_attrs)
      assert resource == Content.get_resource!(resource.id)
    end

    test "delete_resource/1 deletes the resource" do
      resource = resource_fixture()
      assert {:ok, %Resource{}} = Content.delete_resource(resource)
      assert_raise Ecto.NoResultsError, fn -> Content.get_resource!(resource.id) end
    end

    test "change_resource/1 returns a resource changeset" do
      resource = resource_fixture()
      assert %Ecto.Changeset{} = Content.change_resource(resource)
    end
  end
end
