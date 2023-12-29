defmodule QuizzApp.QuizContext.CorrectAnswer do
  use Ecto.Schema

  schema "correct_answer" do
    belongs_to :question, QuizzApp.QuizContext.Question
    belongs_to :answer, QuizzApp.QuizContext.Answer

    timestamps(type: :utc_datetime)
  end
end
