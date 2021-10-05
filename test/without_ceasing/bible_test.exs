defmodule WithoutCeasing.BibleTest do
  use WithoutCeasing.DataCase

  alias WithoutCeasing.Bible

  describe "pending_verses" do
    alias WithoutCeasing.Bible.VerseRevision

    import WithoutCeasing.BibleFixtures

    @invalid_attrs %{book: nil, chapter: nil, order: nil, text: nil}

    test "list_pending_verses/0 returns all pending_verses" do
      pending_verse = pending_verse_fixture()
      assert Bible.list_pending_verses() == [pending_verse]
    end

    test "get_pending_verse!/1 returns the pending_verse with given id" do
      pending_verse = pending_verse_fixture()
      assert Bible.get_pending_verse!(pending_verse.id) == pending_verse
    end

    test "create_pending_verse/1 with valid data creates a pending_verse" do
      valid_attrs = %{book: "some book", chapter: 42, order: 42, text: "some text"}

      assert {:ok, %VerseRevision{} = pending_verse} = Bible.create_pending_verse(valid_attrs)
      assert pending_verse.book == "some book"
      assert pending_verse.chapter == 42
      assert pending_verse.order == 42
      assert pending_verse.text == "some text"
    end

    test "create_pending_verse/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bible.create_pending_verse(@invalid_attrs)
    end

    test "update_pending_verse/2 with valid data updates the pending_verse" do
      pending_verse = pending_verse_fixture()

      update_attrs = %{
        book: "some updated book",
        chapter: 43,
        order: 43,
        text: "some updated text"
      }

      assert {:ok, %VerseRevision{} = pending_verse} =
               Bible.update_pending_verse(pending_verse, update_attrs)

      assert pending_verse.book == "some updated book"
      assert pending_verse.chapter == 43
      assert pending_verse.order == 43
      assert pending_verse.text == "some updated text"
    end

    test "update_pending_verse/2 with invalid data returns error changeset" do
      pending_verse = pending_verse_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Bible.update_pending_verse(pending_verse, @invalid_attrs)

      assert pending_verse == Bible.get_pending_verse!(pending_verse.id)
    end

    test "delete_pending_verse/1 deletes the pending_verse" do
      pending_verse = pending_verse_fixture()
      assert {:ok, %VerseRevision{}} = Bible.delete_pending_verse(pending_verse)
      assert_raise Ecto.NoResultsError, fn -> Bible.get_pending_verse!(pending_verse.id) end
    end

    test "change_pending_verse/1 returns a pending_verse changeset" do
      pending_verse = pending_verse_fixture()
      assert %Ecto.Changeset{} = Bible.change_pending_verse(pending_verse)
    end
  end
end
