defmodule BibleStudySpreadsheetWeb.SheetController do
  use BibleStudySpreadsheetWeb, :controller
  import Phoenix.HTML.Link
  alias BibleStudySpreadsheet.Bible
  alias BibleStudySpreadsheet.Sheet
  alias GoogleApi.Sheets.V4.Api.Spreadsheets

  def new(conn, _params) do
    authenticated = get_session(conn, "authenticated")

    books =
      Bible.get_books()
      |> Enum.map(fn b -> {b.name, b.id} end)

    render(conn, :new, authenticated: authenticated, books: books)
  end

  def create(conn, %{"sheet" => %{"book_id" => book_id}}) do
    book_name = Bible.get_book(book_id).name
    verses = Bible.get_verses(book_id)
    sheets = Sheet.create_sheets(verses, book_name)
    connection = GoogleApi.Sheets.V4.Connection.new(get_session(conn, :access_token))

    case Spreadsheets.sheets_spreadsheets_create(connection, body: sheets) do
      {:ok, response} ->
        conn
        |> put_flash(:info, ["Spreadsheet was created! ", link("link", to: response.spreadsheetUrl)])
        |> redirect(to: Routes.sheet_path(conn, :new))

      _ ->
        conn
        |> put_flash(:error, "There was an error creating the spreadsheet.")
        |> redirect(to: Routes.sheet_path(conn, :new))
    end
  end
end
