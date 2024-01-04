defmodule QuizzApp.QuizPass do
  @moduledoc """
  The QuizPass context.
  """

  import Ecto.Query, warn: false
  alias QuizzApp.Repo

  alias QuizzApp.QuizPass.Passing
  alias QuizzApp.QuizContext.Quiz
  alias QuizzApp.QuizContext.CorrectAnswer

  def get_quiz(id) do
    Quiz
    |> Repo.get!(id)
    |> Repo.preload(questions: [:answers])
    |> Map.from_struct()
  end

  def check_answer_is_correct(question_id, answer_id) when is_binary(answer_id) do
    query = from(c in CorrectAnswer, where: c.question_id == ^question_id)

    correct_answer_id =
      Repo.all(query) |> Enum.map(fn struct -> struct.answer_id end) |> List.first()

    correct_answer_id == String.to_integer(answer_id)
  end

  def check_answer_is_correct(question_id, answer_id) when is_list(answer_id) do
    query = from(c in CorrectAnswer, where: c.question_id == ^question_id)

    correct_answer_ids =
      Repo.all(query) |> Enum.map(fn struct -> struct.answer_id end)

    correct_answers_set = MapSet.new(correct_answer_ids)
    answers_set = MapSet.new(answer_id |> Enum.map(fn a -> String.to_integer(a) end))

    MapSet.equal?(correct_answers_set, answers_set)
  end

  def list_passing do
    Repo.all(Passing) |> Repo.preload(:quiz) |> Repo.preload(:user)
  end

  def get_passing!(id), do: Repo.get!(Passing, id)

  def create_passing(attrs \\ %{}) do
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
