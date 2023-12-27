defmodule QuizzApp.Repo.Migrations.CreateAnswer do
  use Ecto.Migration

  def change do
    create table(:answer) do
      add :answer_text, :string
      add :answer_meta_info, :string

      timestamps(type: :utc_datetime)
    end
  end
end
