# QuizzApp


To start your Phoenix server:
  * Requires Elixir on local machine. Use Erlang/OTP26 minimum.
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


# Test upload file JSON structure

{
  quiz: string,
  description: string,
  questions: [
    {
      text: string,
      additional_data: {
        type: "single_choice" | "multiple_choice",
        options: [
          {
            id: number,
            text: string,
            additional_data: {
              correct: boolean,
            }
          }
        ]
      }
    }
  ]
}


