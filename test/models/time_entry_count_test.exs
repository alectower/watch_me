defmodule WatchMe.TimeEntryCountTest do
  use WatchMe.ModelCase

  alias WatchMe.TimeEntryCount

  @valid_attrs %{app_name: "some content", date: %{day: 17, month: 4, year: 2010}, description: "some content", last_time: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, seconds: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TimeEntryCount.changeset(%TimeEntryCount{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TimeEntryCount.changeset(%TimeEntryCount{}, @invalid_attrs)
    refute changeset.valid?
  end
end
