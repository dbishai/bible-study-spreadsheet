defmodule BibleStudySpreadsheet.Bible.Verse do
  use Ecto.Schema
  import Ecto.Changeset
  alias BibleStudySpreadsheet.Bible.Book

  schema "verses" do
    field :chapter, :integer
    field :text, :string
    field :verse, :integer
    belongs_to(:book, Book)
    timestamps()
  end

  @doc false
  def changeset(verse, attrs) do
    verse
    |> cast(attrs, [:chapter, :verse, :text])
    |> validate_required([:chapter, :verse, :text])
    |> foreign_key_constraint(:book_id)
  end
end
