defmodule WatchMe.TimeEntryCount do
  use WatchMe.Web, :model

  schema "time_entry_counts" do
    field :app_name, :string
    field :date, Ecto.Date
    field :last_time, :string
    field :description, :string
    field :seconds, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:app_name, :date, :last_time, :description, :seconds])
    |> validate_required([:app_name, :date, :last_time, :description, :seconds])
  end
end
