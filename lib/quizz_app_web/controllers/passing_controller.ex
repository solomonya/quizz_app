defmodule QuizzAppWeb.PassingController do
  use QuizzAppWeb, :controller

  alias QuizzApp.QuizPass
  alias QuizzApp.QuizPass.Passing

  def index(conn, _params) do
    passing = QuizPass.list_passing()
    render(conn, :index, passing_collection: passing)
  end

  def new(conn, _params) do
    changeset = QuizPass.change_passing(%Passing{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"passing" => passing_params}) do
    case QuizPass.create_passing(passing_params) do
      {:ok, passing} ->
        conn
        |> put_flash(:info, "Passing created successfully.")
        |> redirect(to: ~p"/passing/#{passing}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    passing = QuizPass.get_passing!(id)
    render(conn, :show, passing: passing)
  end

  def edit(conn, %{"id" => id}) do
    passing = QuizPass.get_passing!(id)
    changeset = QuizPass.change_passing(passing)
    render(conn, :edit, passing: passing, changeset: changeset)
  end

  def update(conn, %{"id" => id, "passing" => passing_params}) do
    passing = QuizPass.get_passing!(id)

    case QuizPass.update_passing(passing, passing_params) do
      {:ok, passing} ->
        conn
        |> put_flash(:info, "Passing updated successfully.")
        |> redirect(to: ~p"/passing/#{passing}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, passing: passing, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    passing = QuizPass.get_passing!(id)
    {:ok, _passing} = QuizPass.delete_passing(passing)

    conn
    |> put_flash(:info, "Passing deleted successfully.")
    |> redirect(to: ~p"/passing")
  end
end
