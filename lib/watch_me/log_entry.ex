defmodule WatchMe.LogEntry do
  def time_from_entry(entry) do
    entry
    |> String.split(~r{'\s})
    |> List.first
    |> String.split("=")
    |> Enum.at(1)
    |> String.trim("'")
    |> time_from_string
  end

  def to_map(line) do
    line
    |> String.split(~r{'\s})
    |> Enum.reduce(%{}, fn (pair, acc) ->
      [key | value] = pair |> String.split("=")
      new_value = value |> Enum.at(0)
      new_value = if new_value == nil do "" else new_value end
      acc
      |> Map.put(
        key |> String.trim("'"),
        new_value |> String.trim("'")
      )
    end)
  end

  def time_from_string(string) do
    {_, time} = string |> Timex.parse("%A, %B %e, %G at %l:%M:%S %p", :strftime)
    time
  end

  def time_diff(one, two) do
    newer = time_from_string(one)
    older = time_from_string(two)
    diff = Timex.diff(newer, older, :seconds)
    diff = cond do
      diff > 2  -> 0
      true      -> diff
    end
  end
end
