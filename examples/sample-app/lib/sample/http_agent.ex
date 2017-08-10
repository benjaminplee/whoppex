defmodule Sample.HttpAgent do
  use Whoppex.Agent
  require Logger

  def create_plan(_host) do
    [
      :say_hello,         # execute function as step
      delay(),            # use default delay with normal dist randomization
      repeat(:get_ip, 3), # repeat specific step 3 times
      delay({2, :second}),# use specific delay with some randomization
      repeat_for_period([ # repeat the sub-plan for 10 seconds
        :get_teapot,
        pause()           # wait for specific time (no random) using default
      ], {10, :second}),
      delay({2, :second}, {4, :second}),  # wait for between min and max ms
      :say_goodbye
    ]
  end

  def say_hello(host) do
    log("Hello World!")
    host
  end

  def say_goodbye(host) do
    log("Bye Bye")
    host
  end

  def get_ip(host) do
    get_and_log_status(host <> "/ip")
    host
  end

  def get_teapot(host) do
    get_and_log_status(host <> "/status/418")
    host
  end

  defp get_and_log_status(url) do
    {:ok, %HTTPoison.Response{status_code: status}} = HTTPoison.get(url)
    log("HTTPRESPONSE - #{url} - #{status}")
  end

  defp log(msg) do log(inspect(self()), msg) end
  defp log(agent_id, msg) do Logger.info("Agent[#{agent_id}] - #{msg}") end

end
