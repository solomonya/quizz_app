defmodule QuizzApp.Repo.Migrations.AddQuizFile do
  use Ecto.Migration

  def change do
    alter table(:quiz) do
      add :quiz_file, :string
    end
  end
end
