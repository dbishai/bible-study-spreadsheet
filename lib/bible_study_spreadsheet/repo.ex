defmodule BibleStudySpreadsheet.Repo do
  use Ecto.Repo,
    otp_app: :bible_study_spreadsheet,
    adapter: Ecto.Adapters.Postgres
end
