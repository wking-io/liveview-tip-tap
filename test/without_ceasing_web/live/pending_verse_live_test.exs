defmodule WithoutCeasingWeb.VerseRevisionLiveTest do
  use WithoutCeasingWeb.ConnCase

  import Phoenix.LiveViewTest
  import WithoutCeasing.BibleFixtures

  @create_attrs %{book: "some book", chapter: 42, order: 42, text: "some text"}
  @update_attrs %{book: "some updated book", chapter: 43, order: 43, text: "some updated text"}
  @invalid_attrs %{book: nil, chapter: nil, order: nil, text: nil}

  defp create_pending_verse(_) do
    pending_verse = pending_verse_fixture()
    %{pending_verse: pending_verse}
  end

  describe "Index" do
    setup [:create_pending_verse]

    test "lists all pending_verses", %{conn: conn, pending_verse: pending_verse} do
      {:ok, _index_live, html} = live(conn, Routes.pending_verse_index_path(conn, :index))

      assert html =~ "Listing Pending verses"
      assert html =~ pending_verse.book
    end

    test "saves new pending_verse", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.pending_verse_index_path(conn, :index))

      assert index_live |> element("a", "New Pending verse") |> render_click() =~
               "New Pending verse"

      assert_patch(index_live, Routes.pending_verse_index_path(conn, :new))

      assert index_live
             |> form("#pending_verse-form", pending_verse: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#pending_verse-form", pending_verse: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.pending_verse_index_path(conn, :index))

      assert html =~ "Pending verse created successfully"
      assert html =~ "some book"
    end

    test "updates pending_verse in listing", %{conn: conn, pending_verse: pending_verse} do
      {:ok, index_live, _html} = live(conn, Routes.pending_verse_index_path(conn, :index))

      assert index_live
             |> element("#pending_verse-#{pending_verse.id} a", "Edit")
             |> render_click() =~
               "Edit Pending verse"

      assert_patch(index_live, Routes.pending_verse_index_path(conn, :edit, pending_verse))

      assert index_live
             |> form("#pending_verse-form", pending_verse: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#pending_verse-form", pending_verse: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.pending_verse_index_path(conn, :index))

      assert html =~ "Pending verse updated successfully"
      assert html =~ "some updated book"
    end

    test "deletes pending_verse in listing", %{conn: conn, pending_verse: pending_verse} do
      {:ok, index_live, _html} = live(conn, Routes.pending_verse_index_path(conn, :index))

      assert index_live
             |> element("#pending_verse-#{pending_verse.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#pending_verse-#{pending_verse.id}")
    end
  end

  describe "Show" do
    setup [:create_pending_verse]

    test "displays pending_verse", %{conn: conn, pending_verse: pending_verse} do
      {:ok, _show_live, html} =
        live(conn, Routes.pending_verse_show_path(conn, :show, pending_verse))

      assert html =~ "Show Pending verse"
      assert html =~ pending_verse.book
    end

    test "updates pending_verse within modal", %{conn: conn, pending_verse: pending_verse} do
      {:ok, show_live, _html} =
        live(conn, Routes.pending_verse_show_path(conn, :show, pending_verse))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Pending verse"

      assert_patch(show_live, Routes.pending_verse_show_path(conn, :edit, pending_verse))

      assert show_live
             |> form("#pending_verse-form", pending_verse: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#pending_verse-form", pending_verse: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.pending_verse_show_path(conn, :show, pending_verse))

      assert html =~ "Pending verse updated successfully"
      assert html =~ "some updated book"
    end
  end
end
