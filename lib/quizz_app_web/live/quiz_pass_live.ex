defmodule QuizzAppWeb.QuizPassLive do
  alias QuizzApp.Accounts
  use QuizzAppWeb, :live_view
  alias QuizzApp.QuizPass

  def render(assigns) do
    ~H"""
    <section class="flex flex-col gap-y-5">
      <header class="flex justify-between align-center">
        <div>
          <h1 class="font-bold text-lg"><%= @title %></h1>
          <button phx-click="submit_test">Finish</button>
        </div>
        <div class="flex flex-col gap-y-3">
          <span>
            Answered: <%= calc_answered_questions_amount(@answered_questions) %> / <%= @questions_amount %>
          </span>
          <span>Score: <%= calc_score(@answered_questions, @score_amount_of_one_question) %></span>
        </div>
      </header>
      <ol class="flex flex-col gap-y-5">
        <%= for question <- @questions do %>
          <li>
            <.question_form question={question} answered_questions={@answered_questions} />
          </li>
        <% end %>
      </ol>
    </section>
    """
  end

  defp calc_answered_questions_amount(answered_questions) do
    answered_questions |> Map.keys() |> length()
  end

  defp calc_score(answered_questions, score_amount_of_one_question) do
    score =
      answered_questions
      |> Map.values()
      |> Enum.reduce(0, fn is_correct, acc ->
        cond do
          is_correct -> acc + score_amount_of_one_question
          !is_correct -> acc
        end
      end)

    Float.round(score / 1, 1)
  end

  defp question_form(assigns) do
    result =
      if Map.has_key?(assigns.answered_questions, "#{assigns.question.id}") do
        if assigns.answered_questions["#{assigns.question.id}"] do
          ~H"""
          <div class="p-5 bg-gray-100 rounded-md border-2 border-green-500">
            <p class="font-bold">Correct Answered</p>
          </div>
          """
        else
          ~H"""
          <div class="p-5 bg-gray-100 rounded-md border-2 border-red-500">
            <p class="font-bold">Incorrect Answered</p>
          </div>
          """
        end
      else
        ~H"""
        <.form
          for={nil}
          class="flex flex-col gap-y-3 bg-gray-100 p-5 rounded-md"
          phx-submit="submit_answer"
        >
          <h5 class="mb-2 text-base">
            <%= @question.question_text %>
          </h5>
          <.answers_list question={@question} />
          <button
            type="submit"
            class="w-24 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg"
          >
            Confirm
          </button>
        </.form>
        """
      end

    result
  end

  defp answers_list(assigns) do
    ~H"""
    <ul class="flex flex-col gap-y-1">
      <%= for answer <- @question.answers do %>
        <.answer question={@question} answer={answer} />
      <% end %>
    </ul>
    """
  end

  defp answer(assigns) do
    question_meta_info = Jason.decode!(assigns.question.question_meta_info)

    result =
      case question_meta_info["type"] do
        "single_choice" ->
          ~H"""
          <div>
            <input type="radio" name={@question.id} id={"answer-#{@answer.id}"} value={@answer.id} />
            <label for={"answer-#{@answer.id}"}><%= @answer.answer_text %></label>
          </div>
          """

        "multiple_choice" ->
          ~H"""
          <div>
            <input
              type="checkbox"
              name={"#{@question.id}[]"}
              id={"answer-#{@answer.id}"}
              value={@answer.id}
            />
            <label for={"answer-#{@answer.id}"}><%= @answer.answer_text %></label>
          </div>
          """
      end

    result
  end

  def mount(%{"quiz_id" => quiz_id}, session, socket) do
    quiz = QuizPass.get_quiz(quiz_id)
    user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:questions, quiz.questions)
     |> assign(:title, quiz.title)
     |> assign(:questions_amount, length(quiz.questions))
     |> assign(:score_amount_of_one_question, 100 / length(quiz.questions))
     |> assign(:quiz_id, quiz.id)
     |> assign(:answered_questions, %{})}
  end

  def handle_event("submit_answer", unsigned_params, socket) do
    {question_id, answer_id} =
      unsigned_params
      |> Map.to_list()
      |> List.first()

    is_correct =
      QuizPass.check_answer_is_correct(
        String.to_integer(question_id),
        answer_id
      )

    {:noreply, update(socket, :answered_questions, &(&1 |> Map.put(question_id, is_correct)))}
  end

  def handle_event("submit_test", _params, socket) do
    attrs = %{
      user_id: socket.assigns.user.id,
      quiz_id: socket.assigns.quiz_id,
      score:
        calc_score(socket.assigns.answered_questions, socket.assigns.score_amount_of_one_question)
    }

    QuizPass.create_passing(attrs)
    {:noreply, push_navigate(socket, to: ~p"/passings")}
  end
end
