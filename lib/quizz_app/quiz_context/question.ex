defmodule QuizzApp.QuizContext.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "question" do
    field :question_text, :string
    field :question_meta_info, :string
    belongs_to :quiz, QuizzApp.QuizContext.Quiz

    many_to_many :answers, QuizzApp.QuizContext.Answer,
      join_through: QuizzApp.QuizContext.CorrectAnswer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:question_text, :question_meta_info, :quiz_id])
    |> validate_required([:question_text, :question_meta_info, :quiz_id])
  end
end
