defmodule QuizzApp.QuizPass.Passing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "passing" do
    field :score, :float
    belongs_to :user, QuizzApp.Accounts.User
    belongs_to :quiz, QuizzApp.QuizContext.Quiz
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(passing, attrs) do
    passing
    |> cast(attrs, [:score, :user_id, :quiz_id])
    |> validate_required([:score, :user_id, :quiz_id])
  end
end
