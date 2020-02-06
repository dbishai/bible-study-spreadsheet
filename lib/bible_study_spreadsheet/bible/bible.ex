defmodule BibleStudySpreadsheet.Bible do
  import Ecto.Query, warn: false
  alias BibleStudySpreadsheet.Repo
  alias BibleStudySpreadsheet.Bible.Book
  alias BibleStudySpreadsheet.Bible.Verse

  def get_books() do
    Repo.all(
      from(b in Book,
        select: b,
        order_by: b.position
      )
    )
  end

  def get_book(book_id) do
    Repo.get(Book, book_id)
  end

  def get_verses(book_id) do
    Repo.all(
      from(v in Verse,
        join: b in assoc(v, :book),
        select: v,
        where: b.id == ^book_id,
        order_by: [asc: v.chapter, asc: v.verse]
      )
    )
  end
end
