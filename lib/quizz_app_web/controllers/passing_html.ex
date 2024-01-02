defmodule QuizzAppWeb.PassingHTML do
  use QuizzAppWeb, :html

  embed_templates "passing_html/*"

  @doc """
  Renders a passing form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def passing_form(assigns)
end
