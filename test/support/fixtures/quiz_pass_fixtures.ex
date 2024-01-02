defmodule QuizzApp.QuizPassFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `QuizzApp.QuizPass` context.
  """

  @doc """
  Generate a passing.
  """
  def passing_fixture(attrs \\ %{}) do
    {:ok, passing} =
      attrs
      |> Enum.into(%{
        score: 120.5
      })
      |> QuizzApp.QuizPass.create_passing()

    passing
  end
end
