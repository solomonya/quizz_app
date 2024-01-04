defmodule QuizzApp.Repo.Migrations.QuestionAnswerRelation do
  use Ecto.Migration

  def change do
    alter table(:answer) do
      add :question_id, references(:question, on_delete: :delete_all)
    end
  end
end
