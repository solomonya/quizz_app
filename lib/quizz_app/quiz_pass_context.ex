defmodule QuizzApp.QuizPassContext do
  @moduledoc """
  The QuizPassContext context.
  """

  import Ecto.Query, warn: false
  alias QuizzApp.Repo

  alias QuizzApp.QuizContext.Quiz

  def get_quiz(id) do
    Quiz
    |> Repo.get!(id)
    |> Repo.preload(questions: [:answers])
    |> Map.from_struct()
  end
end
