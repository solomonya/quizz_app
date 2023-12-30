defmodule QuizzApp.QuizPassContext do
  @moduledoc """
  The QuizPassContext context.
  """

  import Ecto.Query, warn: false
  alias QuizzApp.Repo

  alias QuizzApp.QuizContext.Quiz
  alias QuizzApp.QuizContext.CorrectAnswer

  def get_quiz(id) do
    Quiz
    |> Repo.get!(id)
    |> Repo.preload(questions: [:answers])
    |> Map.from_struct()
  end

  def check_answer_is_correct(question_id, answer_id) do
    query = from(c in CorrectAnswer, where: c.question_id == ^question_id)
    correct_answer_id = Repo.all(query) |> Enum.map(fn struct -> struct.id end) |> List.first()

    correct_answer_id == answer_id
  end
end
