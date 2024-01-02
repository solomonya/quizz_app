defmodule QuizzApp.Repo.Migrations.CreatePassing do
  use Ecto.Migration

  def change do
    create table(:passing) do
      add :score, :float

      timestamps(type: :utc_datetime)
    end

    create table(:quiz_user) do
      add :user_id, references(:users, on_delete: :nothing)
      add :quiz_id, references(:quiz, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end
  end
end
