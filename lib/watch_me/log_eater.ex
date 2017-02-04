defmodule WatchMe.LogEater do
  alias WatchMe.LogEntry
  alias WatchMe.Repo
  alias WatchMe.TimeEntryCount

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    schedule_eat(5000)
    {:ok, []}
  end

  def handle_info(:eat, state) do
    eat
    schedule_eat(900_000)
    {:noreply, state}
  end

  def schedule_eat(seconds) do
    Process.send_after(self(), :eat, seconds)
  end

  def eat do
    Logger.configure(level: :info)
    IO.puts "Syncing with log file #{Timex.now}"

    #{:ok, files} = File.ls(Path.expand("~/.watch_me"))
    #files
    #|> Enum.each(fn (file) ->
    #  File.stream!(Path.expand("~/.watch_me/#{file}"))
    #  |> Enum.map(&insert_into_db/1)
    #end)

    File.stream!(Path.expand("~/.watch_me/watch_me.log"))
    |> Enum.map(&insert_into_db/1)

    IO.puts "Done syncing! #{Timex.now}"
    Logger.configure(level: :debug)

    :ok
  end

  defp insert_into_db(line) do
    Process.sleep(1)
    line_map = line |> LogEntry.to_map
    insert_entry(line_map["app"], line_map)
  end

  defp insert_entry("Google Chrome", entry_map) do
    description = if entry_map["title"] != "" do
      entry_map["title"] |> String.replace("\"", "")
    else
      entry_map["url"]
    end

    insert_entry(
      "Google Chrome",
      :binary.bin_to_list(description) |> to_string,
      entry_map["time"]
    )
  end

  defp insert_entry("iTerm2", entry_map) do
    insert_entry(
      "iTerm",
      "#{entry_map["tab"]} - #{entry_map["file"]}",
      entry_map["time"]
    )
  end

  defp insert_entry(app_name, description, time) do
    date = time |> LogEntry.time_from_string |> Timex.to_date

    {:ok, ecto_date} = date |> Ecto.Date.cast

    args = %{
      app_name: app_name,
      description: :binary.bin_to_list(description)
                   |> to_string
                   |> String.slice(0, 255)
                   |> String.trim,
      date: ecto_date
    }

    model = Repo.get_by TimeEntryCount, args

    {:ok, model} = if model do
      time_one = LogEntry.time_from_string(time)
      time_two = LogEntry.time_from_string(model.last_time)

      if time_one > time_two  do
        update_args = %{last_time: time}

        if LogEntry.time_diff(time, model.last_time) == 1 do
          update_args = update_args |> Map.put(:seconds, model.seconds + 1)
        end

        model_changeset = Ecto.Changeset.change model, update_args

        Repo.update model_changeset
      else
        {:ok, model}
      end
    else
      args = args
             |> Map.put(:seconds, 1)
             |> Map.put(:last_time, time)

      Repo.insert Map.merge(%TimeEntryCount{}, args)
    end

    model
  end
end
