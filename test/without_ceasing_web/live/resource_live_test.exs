defmodule WithoutCeasingWeb.ResourceLiveTest do
  use WithoutCeasingWeb.ConnCase

  import Phoenix.LiveViewTest
  import WithoutCeasing.ContentFixtures

  @create_attrs %{description: "some description", status: :pending, title: "some title"}
  @update_attrs %{description: "some updated description", status: :approved, title: "some updated title"}
  @invalid_attrs %{description: nil, status: nil, title: nil}

  defp create_resource(_) do
    resource = resource_fixture()
    %{resource: resource}
  end

  describe "Index" do
    setup [:create_resource]

    test "lists all resources", %{conn: conn, resource: resource} do
      {:ok, _index_live, html} = live(conn, Routes.resource_index_path(conn, :index))

      assert html =~ "Listing Resources"
      assert html =~ resource.description
    end

    test "saves new resource", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.resource_index_path(conn, :index))

      assert index_live |> element("a", "New Resource") |> render_click() =~
               "New Resource"

      assert_patch(index_live, Routes.resource_index_path(conn, :new))

      assert index_live
             |> form("#resource-form", resource: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#resource-form", resource: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.resource_index_path(conn, :index))

      assert html =~ "Resource created successfully"
      assert html =~ "some description"
    end

    test "updates resource in listing", %{conn: conn, resource: resource} do
      {:ok, index_live, _html} = live(conn, Routes.resource_index_path(conn, :index))

      assert index_live |> element("#resource-#{resource.id} a", "Edit") |> render_click() =~
               "Edit Resource"

      assert_patch(index_live, Routes.resource_index_path(conn, :edit, resource))

      assert index_live
             |> form("#resource-form", resource: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#resource-form", resource: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.resource_index_path(conn, :index))

      assert html =~ "Resource updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes resource in listing", %{conn: conn, resource: resource} do
      {:ok, index_live, _html} = live(conn, Routes.resource_index_path(conn, :index))

      assert index_live |> element("#resource-#{resource.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#resource-#{resource.id}")
    end
  end

  describe "Show" do
    setup [:create_resource]

    test "displays resource", %{conn: conn, resource: resource} do
      {:ok, _show_live, html} = live(conn, Routes.resource_show_path(conn, :show, resource))

      assert html =~ "Show Resource"
      assert html =~ resource.description
    end

    test "updates resource within modal", %{conn: conn, resource: resource} do
      {:ok, show_live, _html} = live(conn, Routes.resource_show_path(conn, :show, resource))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Resource"

      assert_patch(show_live, Routes.resource_show_path(conn, :edit, resource))

      assert show_live
             |> form("#resource-form", resource: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#resource-form", resource: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.resource_show_path(conn, :show, resource))

      assert html =~ "Resource updated successfully"
      assert html =~ "some updated description"
    end
  end
end
