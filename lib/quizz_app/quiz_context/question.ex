defmodule QuizzApp.QuizContext.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "question" do
    field :question_text, :string
    field :question_meta_info, :string
    belongs_to :quiz, QuizzApp.QuizContext.Quiz

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:question_text, :question_meta_info])
    |> validate_required([:question_text, :question_meta_info])
  end
end
