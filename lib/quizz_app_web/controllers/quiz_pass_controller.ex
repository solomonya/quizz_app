defmodule QuizzAppWeb.QuizPassController do
  use QuizzAppWeb, :controller
  alias QuizzApp.QuizPassContext

  def index(conn, _params) do
    render(conn, :index, quiz_collection: [])
  end

  def show(conn, %{"id" => id}) do
    quiz = QuizPassContext.get_quiz(id)
    render(conn, :show, questions: quiz.questions, title: quiz.title)
  end
end
