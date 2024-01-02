defmodule QuizzApp.QuizPassTest do
  use QuizzApp.DataCase

  alias QuizzApp.QuizPass

  describe "passing" do
    alias QuizzApp.QuizPass.Passing

    import QuizzApp.QuizPassFixtures

    @invalid_attrs %{score: nil}

    test "list_passing/0 returns all passing" do
      passing = passing_fixture()
      assert QuizPass.list_passing() == [passing]
    end

    test "get_passing!/1 returns the passing with given id" do
      passing = passing_fixture()
      assert QuizPass.get_passing!(passing.id) == passing
    end

    test "create_passing/1 with valid data creates a passing" do
      valid_attrs = %{score: 120.5}

      assert {:ok, %Passing{} = passing} = QuizPass.create_passing(valid_attrs)
      assert passing.score == 120.5
    end

    test "create_passing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = QuizPass.create_passing(@invalid_attrs)
    end

    test "update_passing/2 with valid data updates the passing" do
      passing = passing_fixture()
      update_attrs = %{score: 456.7}

      assert {:ok, %Passing{} = passing} = QuizPass.update_passing(passing, update_attrs)
      assert passing.score == 456.7
    end

    test "update_passing/2 with invalid data returns error changeset" do
      passing = passing_fixture()
      assert {:error, %Ecto.Changeset{}} = QuizPass.update_passing(passing, @invalid_attrs)
      assert passing == QuizPass.get_passing!(passing.id)
    end

    test "delete_passing/1 deletes the passing" do
      passing = passing_fixture()
      assert {:ok, %Passing{}} = QuizPass.delete_passing(passing)
      assert_raise Ecto.NoResultsError, fn -> QuizPass.get_passing!(passing.id) end
    end

    test "change_passing/1 returns a passing changeset" do
      passing = passing_fixture()
      assert %Ecto.Changeset{} = QuizPass.change_passing(passing)
    end
  end
end
