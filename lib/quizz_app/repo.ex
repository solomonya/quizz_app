defmodule QuizzApp.Repo do
  use Ecto.Repo,
    otp_app: :quizz_app,
    adapter: Ecto.Adapters.SQLite3
end
