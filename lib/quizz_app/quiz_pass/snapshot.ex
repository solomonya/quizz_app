defmodule QuizzApp.QuizPass.Snapshot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "snapshots" do
    field :state, :string
    field :user_id, :id
    field :quiz_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(snapshot, attrs) do
    snapshot
    |> cast(attrs, [:state])
    |> validate_required([:state])
  end
end
