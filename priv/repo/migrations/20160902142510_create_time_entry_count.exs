defmodule WatchMe.Repo.Migrations.CreateTimeEntryCount do
  use Ecto.Migration

  def change do
    create table(:time_entry_counts) do
      add :app_name, :string
      add :date, :date
      add :last_time, :string
      add :description, :string
      add :seconds, :integer

      timestamps()
    end

  end
end
