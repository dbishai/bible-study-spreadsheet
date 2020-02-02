defmodule BibleStudySpreadsheetWeb.PageController do
  use BibleStudySpreadsheetWeb, :controller

  def index(conn, _params) do
    authenticated = get_session(conn, "authenticated")

    if authenticated do
      redirect(conn, to: Routes.sheet_path(conn, :new))
    else
      render(conn, :index, authenticated: false)
    end
  end
end
