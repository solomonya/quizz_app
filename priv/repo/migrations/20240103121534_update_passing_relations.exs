defmodule QuizzApp.Repo.Migrations.UpdatePassingRelations do
  use Ecto.Migration

  def change do
    alter table(:passing) do
      add :user_id, references(:users, on_delete: :nothing)
      add :quiz_id, references(:quiz, on_delete: :nothing)
    end
  end
end
