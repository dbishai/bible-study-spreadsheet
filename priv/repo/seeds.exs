# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BibleStudySpreadsheet.Repo.insert!(%BibleStudySpreadsheet.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
import Ecto.Query, only: [from: 2]
alias BibleStudySpreadsheet.Repo
alias BibleStudySpreadsheet.Bible.Verse
alias BibleStudySpreadsheet.Bible.Book

def get_bible(filename) do
  File.stream!(filename)
  |> Enum.map(&Jason.decode/1)
end

book_positions = %{
  "Acts of the Apostles" => 43,
  "Numbers" => 3,
  "Exodus" => 1,
  "Genesis" => 0,
  "Job" => 17,
  "Ecclesiastes" => 20,
  "Colossians" => 50,
  "Esther" => 16,
  "Judges" => 6,
  "Daniel" => 26,
  "2 Chronicles" => 13,
  "Revelation" => 65,
  "1 Peter" => 59,
  "Jude" => 64,
  "2 Corinthians" => 46,
  "2 Timothy" => 54,
  "Nehemiah" => 15,
  "Jonah" => 31,
  "1 Timothy" => 53,
  "Ezra" => 14,
  "Philemon" => 56,
  "Amos" => 29,
  "Lamentations" => 24,
  "Psalms" => 18,
  "1 John" => 61,
  "Joshua" => 5,
  "2 Peter" => 60,
  "Malachi" => 38,
  "Nahum" => 33,
  "Haggai" => 36,
  "Habakkuk" => 34,
  "Galatians" => 47,
  "Titus" => 55,
  "1 Samuel" => 8,
  "1 Thessalonians" => 51,
  "1 Kings" => 10,
  "Deuteronomy" => 4,
  "Micah" => 32,
  "Mark" => 40,
  "Zephaniah" => 35,
  "Isaiah" => 22,
  "2 John" => 62,
  "Hebrews" => 57,
  "Leviticus" => 2,
  "Romans" => 44,
  "Jeremiah" => 23,
  "Zechariah" => 37,
  "3 John" => 63,
  "Ruth" => 7,
  "2 Kings" => 11,
  "1 Chronicles" => 12,
  "Luke" => 41,
  "Proverbs" => 19,
  "Obadiah" => 30,
  "Matthew" => 39,
  "Ezekiel" => 25,
  "2 Thessalonians" => 52,
  "Joel" => 28,
  "John" => 42,
  "Hosea" => 27,
  "Song of Solomon" => 21,
  "1 Corinthians" => 45,
  "James" => 58,
  "Ephesians" => 48,
  "2 Samuel" => 9,
  "Philippians" => 49
}

bible = get_bible("/tmp/asv.json")

# books =
#   Enum.map(bible, fn row ->
#     {:ok,
#      %{
#        "book_name" => book_name,
#        "chapter" => chapter
#      }} = row

#     book_name
#   end)
#   |> Enum.uniq()
#   |> Enum.with_index()
#   |> Enum.into(%{})

# IO.inspect(books, limit: 200)

books =
  Enum.map(bible, fn row ->
    {:ok,
     %{
       "book_name" => book_name,
       "chapter" => chapter
     }} = row

    [book_name, chapter]
  end)
  |> Enum.uniq()
  |> Enum.frequencies_by(fn x -> Enum.take(x, 1) end)

for {book, chapters} <- books do
  book = List.first(book)

  Repo.insert!(%Book{
    name: book,
    chapters: chapters,
    position: Map.fetch!(book_positions, book)
  })
end

for row <- bible do
  {:ok,
   %{
     "book_name" => book_name,
     "chapter" => chapter,
     "verse" => verse,
     "text" => text
   }} = row

  book_id = Repo.one!(from b in Book, where: b.name == ^book_name).id

  Repo.insert!(%Verse{
    book_id: book_id,
    text: text,
    chapter: chapter,
    verse: verse
  })
end
