defmodule QuizzApp.Repo.Migrations.CreateQuestion do
  use Ecto.Migration

  def change do
    create table(:question) do
      add :question_text, :string
      add :question_meta_info, :string
      add :quiz_id, references(:quiz, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
