defmodule QuizzAppWeb.QuizController do
  use QuizzAppWeb, :controller

  alias QuizzApp.QuizContext
  alias QuizzApp.QuizContext.Quiz

  def index(conn, _params) do
    quiz = QuizContext.list_quiz()
    render(conn, :index, quiz_collection: quiz)
  end

  def new(conn, _params) do
    changeset = QuizContext.change_quiz(%Quiz{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"quiz" => quiz_params}) do
    quiz_params |> IO.inspect()

    case QuizContext.create_quiz(quiz_params) do
      {:ok, quiz} ->
        if upload = quiz_params["quiz_file"] do
          extension = Path.extname(upload.filename)
          File.cp(upload.path, "/media/#{quiz.id}_quiz_file#{extension}")
        end

        conn
        |> put_flash(:info, "Quiz created successfully.")
        |> redirect(to: ~p"/quiz/#{quiz}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    quiz = QuizContext.get_quiz!(id)
    render(conn, :show, quiz: quiz)
  end

  def edit(conn, %{"id" => id}) do
    quiz = QuizContext.get_quiz!(id)
    changeset = QuizContext.change_quiz(quiz)
    render(conn, :edit, quiz: quiz, changeset: changeset)
  end

  def update(conn, %{"id" => id, "quiz" => quiz_params}) do
    quiz = QuizContext.get_quiz!(id)

    case QuizContext.update_quiz(quiz, quiz_params) do
      {:ok, quiz} ->
        conn
        |> put_flash(:info, "Quiz updated successfully.")
        |> redirect(to: ~p"/quiz/#{quiz}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, quiz: quiz, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    quiz = QuizContext.get_quiz!(id)
    {:ok, _quiz} = QuizContext.delete_quiz(quiz)

    conn
    |> put_flash(:info, "Quiz deleted successfully.")
    |> redirect(to: ~p"/quiz")
  end
end
