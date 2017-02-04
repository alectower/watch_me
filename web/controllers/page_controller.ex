defmodule WatchMe.PageController do
  use WatchMe.Web, :controller
  alias WatchMe.LogEntries

  def index(conn, params) do
    ecto_start_date =
      LogEntries.start_date(params["start_date"])
      |> LogEntries.to_ecto_date
    ecto_end_date =
      LogEntries.end_date(params["end_date"])
      |> LogEntries.to_ecto_date

    conn
    |> assign(:start_date, ecto_start_date)
    |> assign(:end_date, ecto_end_date)
    |> assign(
      :chrome_entries,
      LogEntries.entries(:chrome, params["start_date"], params["end_date"])
    )
    |> assign(
      :iterm_entries,
      LogEntries.entries(:iterm, params["start_date"], params["end_date"])
    )
    |> render("index.html")
  end
end
