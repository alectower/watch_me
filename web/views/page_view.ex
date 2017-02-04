defmodule WatchMe.PageView do
  use WatchMe.Web, :view
  alias WatchMe.LogEntries

  def seconds_to_hours(seconds) do
    seconds / 3600 |> Float.round(4)
  end
end
