defmodule WatchMe.Logger do
  def start_link do
    GenServer.start_link(__MODULE__, [], name: :watch_me_logger)
  end

  def init([]) do
    start_logger
    schedule_check(1)
    {:ok, []}
  end

  def handle_info(:start_logger, state) do
    start_logger
    schedule_check(1_000_000)
    {:noreply, state}
  end

  def handle_info(:stop_logger, state) do
    {:noreply, state}
  end

  def schedule_check(seconds) do
    Process.send_after(self(), :start_logger, seconds)
  end

  def start_logger do
    if logger_pids |> Enum.empty? do
      IO.puts "Starting logger"
      spawn fn ->
        System.cmd "osascript", ["lib/watch_me/logger.scpt"]
      end
    else
      IO.puts "Logger already started"
    end
  end

  def stop_logger do
    pids = logger_pids
    pids
    |> Enum.each(fn (l) ->
      IO.puts "Killing process #{l}"
      System.cmd("kill", ["-9", l])
    end)
    pids
  end

  defp logger_pids do
    {text, _} = System.cmd("ps", ["aux"])
    text
    |> String.split("\n")
    |> Enum.filter(fn (l) ->
      l |> String.contains?("logger.scpt")
    end)
    |> Enum.map(fn (l) ->
      l
      |> String.split(~r{\s+})
      |> Enum.at(1)
    end)
  end
end
