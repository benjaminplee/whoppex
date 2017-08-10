defmodule Sample.PickTheIconAgent do
  use Whoppex.Agent
  require Logger

  def init(_) do
    "https://swimming-in-elixir.firebaseapp.com/picktheicon/"
  end

  def create_plan(_host) do
    [
      :load_index,
      repeat_for_period([
        delay({5, :second}),
        :load_play,
        repeat([
          :get_question_ajax,
          delay({10, :second})
        ], :rand.uniform(50)),
        :score_ajax,
        :load_leaders,
        :get_leaders_ajax
      ], {60, :second})
    ]
  end

  def load_index(host) do
    get_and_log_status(host <> "/index.html")
    host
  end

  def load_play(host) do
    get_and_log_status(host <> "/play.html")
    host
  end

  def load_leaders(host) do
    get_and_log_status(host <> "/leaders.html")
    host
  end

  defp get_and_log_status(url) do
    {:ok, %HTTPoison.Response{status_code: status}} = HTTPoison.get(url)
    log("HTTPRESPONSE - #{url} - #{status}")
  end

  defp log(msg) do log(inspect(self()), msg) end
  defp log(agent_id, msg) do Logger.info("Agent[#{agent_id}] - #{msg}") end

end
