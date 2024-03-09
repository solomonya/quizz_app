defmodule QuizzApp.Repo.Migrations.CreateSnapshots do
  use Ecto.Migration

  def change do
    create table(:snapshots) do
      add :state, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :quiz_id, references(:quiz, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:snapshots, [:user_id])
    create index(:snapshots, [:quiz_id])
  end
end
