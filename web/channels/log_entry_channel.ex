defmodule WatchMe.LogEntryChannel do
  use Phoenix.Channel
  alias WatchMe.LogEntries

  def join("entries", message, socket) do
    {:ok, socket}
  end

  def handle_in("update", data, socket) do
    IO.inspect data

    ecto_start_date =
      LogEntries.start_date(data["start_date"])
      |> LogEntries.to_ecto_date

    ecto_end_date =
      LogEntries.end_date(data["end_date"])
      |> LogEntries.to_ecto_date

    WatchMe.Endpoint.broadcast! "entries", "update",
      %{entries: Phoenix.View.render_to_string(WatchMe.PageView, "index.html",
          start_date: ecto_start_date, end_date: ecto_end_date,
          chrome_entries: LogEntries.entries(:chrome, data["start_date"], data["end_date"]),
          iterm_entries: LogEntries.entries(:iterm, data["start_date"], data["end_date"]))
      }

    {:noreply, socket}
  end
end
