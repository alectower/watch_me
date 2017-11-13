defmodule WatchMe.LogEntries do
  import Ecto
  import Ecto.Query
  alias WatchMe.Repo

  def entries(:chrome, start_date, end_date),
    do: entries("Google Chrome", start_date, end_date)

  def entries(:iterm, start_date, end_date),
    do: entries("iTerm", start_date, end_date)

  def entries(name, nil, nil) do
    {:ok, date} = Timex.local |> Ecto.Date.cast
    Repo.all(
      from(
        a in WatchMe.TimeEntryCount,
        where: a.app_name == ^name,
        where: a.date == ^date,
        order_by: [asc: :description, desc: :seconds]
      )
    )
  end

  def entries(name, start_date, nil) do
    {:ok, date} = start_date |> Ecto.Date.cast
    Repo.all(
      from(
        a in WatchMe.TimeEntryCount,
        where: a.app_name == ^name,
        where: a.date == ^date,
        order_by: [asc: :description, desc: :seconds]
      )
    )
  end

  def entries(name, start_date, end_date) do
    start_date = start_date(start_date) |> to_ecto_date
    end_date = end_date(end_date) |> to_ecto_date
    Repo.all(
      from(
        a in WatchMe.TimeEntryCount,
        where: a.app_name == ^name,
        where: a.date >= ^start_date and a.date <= ^end_date,
        order_by: [asc: :description, desc: :seconds]
      )
    )
  end

  def to_ecto_date(%Date{} = date) do
    {:ok, ecto_date} = date |> Ecto.Date.cast
    ecto_date
  end

  def start_date(date) do
    case Timex.parse(date, "{YYYY}-{0M}-{D}") do
      {:ok, date}       -> date |> Timex.to_date
      {:error, :badarg} -> Timex.local |> Timex.to_date
    end
  end

  def end_date(date) do
    case Timex.parse(date, "{YYYY}-{0M}-{D}") do
      {:ok, date}       -> date |> Timex.to_date
      {:error, :badarg} -> start_date(nil) |> Timex.shift(days: 1)
    end
  end
end
