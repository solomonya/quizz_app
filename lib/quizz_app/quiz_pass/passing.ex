defmodule QuizzApp.QuizPass.Passing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "passing" do
    field :score, :float
    many_to_many :users, QuizzApp.Accounts.User, join_through: QuizzApp.QuizPass.QuizUser
    many_to_many :quizes, QuizzApp.QuizContext.Quiz, join_through: QuizzApp.QuizPass.QuizUser
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(passing, attrs) do
    passing
    |> cast(attrs, [:score])
    |> validate_required([:score])
  end
end
