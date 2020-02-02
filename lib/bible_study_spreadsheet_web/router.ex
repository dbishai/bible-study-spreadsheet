defmodule BibleStudySpreadsheetWeb.Router do
  use BibleStudySpreadsheetWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BibleStudySpreadsheetWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/sheets", SheetController, only: [:new, :create]

  end

  scope "/auth", BibleStudySpreadsheetWeb do
    pipe_through :browser

    get "/", AuthController, :index
    get "/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end
  # Other scopes may use custom stacks.
  # scope "/api", BibleStudySpreadsheetWeb do
  #   pipe_through :api
  # end
end
