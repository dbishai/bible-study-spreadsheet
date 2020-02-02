defmodule BibleStudySpreadsheet.Bible.Book do
  use Ecto.Schema
  import Ecto.Changeset
  alias BibleStudySpreadsheet.Bible.Verse

  schema "books" do
    field :name, :string
    field :chapters, :integer
    field :position, :integer
    has_many :verses, Verse

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:name, :chapters])
    |> validate_required([:name, :chapters])
  end
end
