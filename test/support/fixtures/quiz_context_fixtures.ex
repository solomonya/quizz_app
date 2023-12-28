defmodule QuizzApp.QuizContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `QuizzApp.QuizContext` context.
  """

  @doc """
  Generate a quiz.
  """
  def quiz_fixture(attrs \\ %{}) do
    {:ok, quiz} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> QuizzApp.QuizContext.create_quiz()

    quiz
  end
end
