defmodule QuizzApp.Repo.Migrations.CreateCorrectAnswer do
  use Ecto.Migration

  def change do
    create table(:correct_answer) do
      add :question_id, references(:question, on_delete: :nothing)
      add :answer_id, references(:answer, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:correct_answer, [:question_id])
    create index(:correct_answer, [:answer_id])
  end
end
