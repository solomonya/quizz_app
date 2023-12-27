defmodule QuizzApp.Repo.Migrations.CreateQuiz do
  use Ecto.Migration

  def change do
    create table(:quiz) do
      add :title, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
