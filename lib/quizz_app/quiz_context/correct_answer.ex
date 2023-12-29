defmodule QuizzApp.QuizContext.CorrectAnswer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "correct_answer" do
    field :question_id, :id
    field :answer_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(correct_answer, attrs) do
    correct_answer
    |> cast(attrs, [])
    |> validate_required([])
  end
end
