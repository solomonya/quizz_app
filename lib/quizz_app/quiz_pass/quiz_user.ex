defmodule QuizzApp.QuizPass.QuizUser do
  use Ecto.Schema

  schema "quiz_user" do
    belongs_to :user, QuizzApp.Accounts.User
    belongs_to :quiz, QuizzApp.QuizContext.Quiz
    belongs_to :quiz_pass, QuizzApp.QuizPass.Passing
    timestamps(type: :utc_datetime)
  end
end
