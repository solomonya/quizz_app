defmodule QuizzAppWeb.PassingControllerTest do
  use QuizzAppWeb.ConnCase

  import QuizzApp.QuizPassFixtures

  @create_attrs %{score: 120.5}
  @update_attrs %{score: 456.7}
  @invalid_attrs %{score: nil}

  describe "index" do
    test "lists all passing", %{conn: conn} do
      conn = get(conn, ~p"/passing")
      assert html_response(conn, 200) =~ "Listing Passing"
    end
  end

  describe "new passing" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/passing/new")
      assert html_response(conn, 200) =~ "New Passing"
    end
  end

  describe "create passing" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/passing", passing: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/passing/#{id}"

      conn = get(conn, ~p"/passing/#{id}")
      assert html_response(conn, 200) =~ "Passing #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/passing", passing: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Passing"
    end
  end

  describe "edit passing" do
    setup [:create_passing]

    test "renders form for editing chosen passing", %{conn: conn, passing: passing} do
      conn = get(conn, ~p"/passing/#{passing}/edit")
      assert html_response(conn, 200) =~ "Edit Passing"
    end
  end

  describe "update passing" do
    setup [:create_passing]

    test "redirects when data is valid", %{conn: conn, passing: passing} do
      conn = put(conn, ~p"/passing/#{passing}", passing: @update_attrs)
      assert redirected_to(conn) == ~p"/passing/#{passing}"

      conn = get(conn, ~p"/passing/#{passing}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, passing: passing} do
      conn = put(conn, ~p"/passing/#{passing}", passing: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Passing"
    end
  end

  describe "delete passing" do
    setup [:create_passing]

    test "deletes chosen passing", %{conn: conn, passing: passing} do
      conn = delete(conn, ~p"/passing/#{passing}")
      assert redirected_to(conn) == ~p"/passing"

      assert_error_sent 404, fn ->
        get(conn, ~p"/passing/#{passing}")
      end
    end
  end

  defp create_passing(_) do
    passing = passing_fixture()
    %{passing: passing}
  end
end
