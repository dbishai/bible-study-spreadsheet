defmodule BibleStudySpreadsheet.Sheet do
  alias GoogleApi.Sheets.V4.Model
  alias BibleStudySpreadsheet.Bible
  alias BibleStudySpreadsheet.Bible.Book

  def create_sheets(book, title) do
    chapters = Enum.group_by(book, fn v -> v.chapter end)

    sheets =
      for c <- Enum.sort(Map.keys(chapters)) do
        rows = add_rows(Map.get(chapters, c))

        create_sheet(rows, "Chapter #{c}")
      end

    properties = %Model.SpreadsheetProperties{
      title: title
    }

    %Model.Spreadsheet{
      sheets: sheets,
      properties: properties
    }
  end

  defp create_sheet(rows, title) do
    properties = %Model.SheetProperties{
      title: title
    }

    grid_data = %Model.GridData{
      rowData: List.insert_at(rows, 0, add_header()),
      startColumn: 0,
      startRow: 0
    }

    %Model.Sheet{
      data: [grid_data],
      properties: properties
    }
  end

  defp add_rows(chapter) do
    verses =
      chapter
      |> Enum.sort_by(fn c -> c.verse end)
      |> Enum.map(&create_row_data/1)
  end

  defp create_row_data(chapter) do
    %Model.RowData{
      values: [add_cell(chapter.verse), add_cell(chapter.text)]
    }
  end

  defp add_cell(data) when is_binary(data) do
    %Model.CellData{
      userEnteredValue: %Model.ExtendedValue{
        stringValue: data
      }
    }
  end

  defp add_cell(data) when is_integer(data) do
    %Model.CellData{
      userEnteredValue: %Model.ExtendedValue{
        numberValue: data
      }
    }
  end

  defp add_header() do
    %Model.RowData{
      values: [add_cell("Verse"), add_cell("Text")]
    }
  end
end
