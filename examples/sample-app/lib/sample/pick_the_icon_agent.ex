defmodule Sample.PickTheIconAgent do
  use Whoppex.Agent
  require Logger

  def init(_) do
    "https://swimming-in-elixir.firebaseapp.com/"
  end

  def create_plan(_host) do
    [
      :load_index,
      repeat([
        delay({5, :second}),
        :load_play,
        repeat([
          :get_question_ajax,
          delay({1, :second}, {5, :second})
        ], :rand.uniform(50)),
        :post_score_ajax,
        :load_leaders,
        :get_scores_ajax
      ], 2)
    ]
  end

  def load_index(host) do
    get_and_log_status(host <> "picktheicon/index.html")
    host
  end

  def load_play(host) do
    get_and_log_status(host <> "picktheicon/play.html")
    host
  end

  def load_leaders(host) do
    get_and_log_status(host <> "picktheicon/leaders.html")
    host
  end

  def get_question_ajax(host) do
    get_and_log_status(host <> "getRandIcons")
    host
  end

  def get_scores_ajax(host) do
    get_and_log_status(host <> "getScores")
    host
  end

  def post_score_ajax(host) do
    name = "WHOPPEX_AGENT_" <> Sample.Utils.rnd_id()
    score = 1
    post_and_log_status(host <> "saveScore?username=#{name}&score=#{score}")
    host
  end

  defp get_and_log_status(url) do
    {:ok, %HTTPoison.Response{status_code: status}} = HTTPoison.get(url, [], [timeout: 10000, recv_timeout: 10000, follow_redirect: true])
    log("GET - #{url} - #{status}")
  end

  defp post_and_log_status(url) do
    {:ok, %HTTPoison.Response{status_code: status}} = HTTPoison.post(url, "", [{"Content-Type", "application/json"}], [timeout: 10000, recv_timeout: 10000, follow_redirect: true])
    log("POST - #{url} - #{status}")
  end

  defp log(msg) do log(inspect(self()), msg) end
  defp log(agent_id, msg) do Logger.info("Agent[#{agent_id}] - #{msg}") end

end
