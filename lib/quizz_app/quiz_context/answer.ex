defmodule QuizzApp.QuizContext.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answer" do
    field :answer_text, :string
    field :answer_meta_info, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:answer_text, :answer_meta_info])
    |> validate_required([:answer_text, :answer_meta_info])
  end
end
