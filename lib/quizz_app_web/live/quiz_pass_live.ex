defmodule QuizzAppWeb.QuizPassLive do
  use QuizzAppWeb, :live_view
  alias QuizzApp.QuizPassContext

  def render(assigns) do
    ~H"""
    <section class="flex flex-col gap-y-5">
      <header class="flex justify-between align-center">
        <h1 class="font-bold text-lg"><%= @title %></h1>
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
    answered_questions
    |> Map.values()
    |> Enum.reduce(0, fn is_correct, acc ->
      cond do
        is_correct -> acc + score_amount_of_one_question
        !is_correct -> acc
      end
    end)
  end

  def handle_event("submit_answer", unsigned_params, socket) do
    {question_id, answer_id} =
      unsigned_params
      |> Map.to_list()
      |> List.first()

    is_correct =
      QuizPassContext.check_answer_is_correct(
        String.to_integer(question_id),
        String.to_integer(answer_id)
      )

    {:noreply, update(socket, :answered_questions, &(&1 |> Map.put(question_id, is_correct)))}
  end

  def question_form(assigns) do
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
          <ul class="flex flex-col gap-y-1">
            <%= for answer <- @question.answers do %>
              <div>
                <input type="radio" name={@question.id} id={"answer-#{answer.id}"} value={answer.id} />
                <label for={"answer-#{answer.id}"}><%= answer.answer_text %></label>
              </div>
            <% end %>
          </ul>
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

  def mount(%{"quiz_id" => quiz_id}, _session, socket) do
    quiz = QuizPassContext.get_quiz(quiz_id)

    {:ok,
     socket
     |> assign(:questions, quiz.questions)
     |> assign(:title, quiz.title)
     |> assign(:questions_amount, length(quiz.questions))
     |> assign(:score_amount_of_one_question, 100 / length(quiz.questions))
     |> assign(:answered_questions, %{})}
  end
end
