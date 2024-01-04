defmodule QuizzApp.QuizContext do
  @moduledoc """
  The QuizContext context.
  """

  import Ecto.Query, warn: false
  alias QuizzApp.QuizContext.CorrectAnswer
  alias QuizzApp.QuizContext.Answer
  alias QuizzApp.QuizContext.Question
  alias QuizzApp.Repo

  alias QuizzApp.QuizContext.Quiz

  @priv_dir_path Application.app_dir(:quizz_app, "priv")
  @doc """
  Returns the list of quiz.

  ## Examples

      iex> list_quiz()
      [%Quiz{}, ...]

  """
  def list_quiz do
    Repo.all(Quiz)
  end

  @doc """
  Gets a single quiz.

  Raises `Ecto.NoResultsError` if the Quiz does not exist.

  ## Examples

      iex> get_quiz!(123)
      %Quiz{}

      iex> get_quiz!(456)
      ** (Ecto.NoResultsError)

  """
  def get_quiz!(id), do: Repo.get!(Quiz, id)

  @doc """
  Creates a quiz.

  ## Examples

      iex> create_quiz(%{field: value})
      {:ok, %Quiz{}}

      iex> create_quiz(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_quiz(attrs \\ %{}) do
    res =
      %Quiz{}
      |> Quiz.changeset(attrs)
      |> Repo.insert()

    {:ok, upload_path} = upload_quiz_file(attrs["quiz_file"], res)
    fill_questions_from_file(upload_path, res)
    res
  end

  defp upload_quiz_file(upload, {:ok, quiz}) do
    upload_path =
      upload.filename
      |> Path.extname()
      |> (fn ext ->
            Path.join(@priv_dir_path, "media/#{quiz.id}_quiz_file#{ext}")
          end).()

    case File.cp(upload.path, upload_path) do
      :ok -> add_quiz_file_path(quiz, %{"quiz_file" => upload_path})
    end

    {:ok, upload_path}
  end

  def fill_questions_from_file(upload_path, {:ok, quiz}) do
    questions =
      upload_path |> File.read!() |> Jason.decode!() |> Map.get("quiz") |> Map.get("questions")

    Enum.map(questions, fn q -> process_question(q, quiz.id) end)

    {:ok, questions}
  end

  defp process_question(
         %{
           "text" => text,
           "additional_data" => additional_data,
           "options" => options
         },
         quiz_id
       ) do
    question =
      %Question{
        question_text: text,
        question_meta_info: Jason.encode!(additional_data),
        quiz_id: quiz_id
      }
      |> Repo.insert!()

    Enum.each(options, fn option ->
      answer =
        %Answer{
          answer_text: option["text"],
          answer_meta_info: Jason.encode!(option["additional_data"]),
          question_id: question.id
        }
        |> Repo.insert!()

      if option["additional_data"]["correct"] do
        %CorrectAnswer{question_id: question.id, answer_id: answer.id} |> Repo.insert!()
      end
    end)
  end

  @doc """
  Updates a quiz.

  ## Examples

      iex> update_quiz(quiz, %{field: new_value})
      {:ok, %Quiz{}}

      iex> update_quiz(quiz, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_quiz(%Quiz{} = quiz, attrs) do
    quiz
    |> Quiz.changeset(attrs)
    |> Repo.update()
  end

  def add_quiz_file_path(%Quiz{} = quiz, attrs) do
    quiz
    |> Ecto.Changeset.cast(attrs, [:quiz_file])
    |> Repo.update()
  end

  @doc """
  Deletes a quiz.

  ## Examples

      iex> delete_quiz(quiz)
      {:ok, %Quiz{}}

      iex> delete_quiz(quiz)
      {:error, %Ecto.Changeset{}}

  """
  def delete_quiz(%Quiz{} = quiz) do
    Repo.delete(quiz)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking quiz changes.

  ## Examples

      iex> change_quiz(quiz)
      %Ecto.Changeset{data: %Quiz{}}

  """
  def change_quiz(%Quiz{} = quiz, attrs \\ %{}) do
    Quiz.changeset(quiz, attrs)
  end
end
