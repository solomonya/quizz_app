defmodule QuizzApp.QuizPass do
  @moduledoc """
  The QuizPass context.
  """

  import Ecto.Query, warn: false
  alias QuizzApp.Repo

  alias QuizzApp.QuizPass.{Passing, QuizUser}
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

  def list_passing do
    Repo.all(Passing)
  end

  def get_passing!(id), do: Repo.get!(Passing, id)

  def create_passing(attrs \\ %{}) do
    %QuizUser{quiz_id: attrs.quiz_id, user_id: attrs.user_id}
    |> Repo.insert()

    %Passing{}
    |> Passing.changeset(attrs)
    |> Repo.insert()
  end

  def update_passing(%Passing{} = passing, attrs) do
    passing
    |> Passing.changeset(attrs)
    |> Repo.update()
  end

  def delete_passing(%Passing{} = passing) do
    Repo.delete(passing)
  end

  def change_passing(%Passing{} = passing, attrs \\ %{}) do
    Passing.changeset(passing, attrs)
  end
end
