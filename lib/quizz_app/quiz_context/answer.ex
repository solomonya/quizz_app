defmodule QuizzApp.QuizContext.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answer" do
    field :answer_text, :string
    field :answer_meta_info, :string

    many_to_many :questions, QuizzApp.QuizContext.Question,
      join_through: QuizzApp.QuizContext.CorrectAnswer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:answer_text, :answer_meta_info])
    |> validate_required([:answer_text, :answer_meta_info])
  end
end
