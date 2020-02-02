defmodule BibleStudySpreadsheet.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :name, :string
      add :chapters, :integer
      add :position, :integer

      timestamps()
    end

  end
end
