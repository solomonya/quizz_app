defmodule QuizzApp.QuizContext.Quiz do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quiz" do
    field :description, :string
    field :title, :string
    field :quiz_file, :string
    has_many :questions, QuizzApp.QuizContext.Question

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(quiz, attrs) do
    quiz
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
