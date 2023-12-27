defmodule QuizzAppWeb.QuizController do
  use QuizzAppWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def create(conn, %{"file" => _file_params}) do
    put_flash(conn, :info, "Quiz successfully uploaded!")
  end

  def index(conn, _params) do
    render(conn, :index, layout: false)
  end
end

defmodule QuizzAppWeb.QuizHTML do
  use QuizzAppWeb, :html

  def index(assigns) do
    ~H"""
    <h1>Hello world</h1>
    <form path="/quiz/create/" method="POST">
      <input type="file" name="file" />
      <input type="submit" value="Загрузить" />
    </form>
    """
  end
end
