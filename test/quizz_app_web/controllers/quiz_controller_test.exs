defmodule QuizzAppWeb.QuizControllerTest do
  use QuizzAppWeb.ConnCase

  import QuizzApp.QuizContextFixtures

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  describe "index" do
    test "lists all quiz", %{conn: conn} do
      conn = get(conn, ~p"/quiz")
      assert html_response(conn, 200) =~ "Listing Quiz"
    end
  end

  describe "new quiz" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/quiz/new")
      assert html_response(conn, 200) =~ "New Quiz"
    end
  end

  describe "create quiz" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/quiz", quiz: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/quiz/#{id}"

      conn = get(conn, ~p"/quiz/#{id}")
      assert html_response(conn, 200) =~ "Quiz #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/quiz", quiz: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Quiz"
    end
  end

  describe "edit quiz" do
    setup [:create_quiz]

    test "renders form for editing chosen quiz", %{conn: conn, quiz: quiz} do
      conn = get(conn, ~p"/quiz/#{quiz}/edit")
      assert html_response(conn, 200) =~ "Edit Quiz"
    end
  end

  describe "update quiz" do
    setup [:create_quiz]

    test "redirects when data is valid", %{conn: conn, quiz: quiz} do
      conn = put(conn, ~p"/quiz/#{quiz}", quiz: @update_attrs)
      assert redirected_to(conn) == ~p"/quiz/#{quiz}"

      conn = get(conn, ~p"/quiz/#{quiz}")
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, quiz: quiz} do
      conn = put(conn, ~p"/quiz/#{quiz}", quiz: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Quiz"
    end
  end

  describe "delete quiz" do
    setup [:create_quiz]

    test "deletes chosen quiz", %{conn: conn, quiz: quiz} do
      conn = delete(conn, ~p"/quiz/#{quiz}")
      assert redirected_to(conn) == ~p"/quiz"

      assert_error_sent 404, fn ->
        get(conn, ~p"/quiz/#{quiz}")
      end
    end
  end

  defp create_quiz(_) do
    quiz = quiz_fixture()
    %{quiz: quiz}
  end
end
