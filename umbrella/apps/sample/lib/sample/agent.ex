defmodule Sample.Agent do
  use Whoppex.Agent
  require Logger

  def create_plan(_state) do
    Logger.info log("Reporting For Duty")
    [
      :say_hello,         # execute function as step
      delay(),            # use default delay with normal dist randomization
      repeat(:get_ip),    # repeat specific step (function name atom) default times
      delay(2000),        # use specific delay (in ms) with normal dist
      repeat([            # repeat the sub-plan 3 times
        :get_teapot,
        pause()           # wait for specific time (no random) using default
      ], 3),
      delay(2000, 4000),  # wait for between min and max ms
      forever([           # loop forever on the passed in sub-plan
        :say_goodbye,
        delay()
      ])
    ]
  end

  def say_hello(state) do
    Logger.info log("hello world")
    state
  end

  def say_goodbye(state) do
    Logger.info log("bye bye")
    state
  end

  def get_ip(state) do
    get_and_log_status("http://httpbin.org/ip")
    state
  end

  def get_teapot(state) do
    get_and_log_status("http://httpbin.org/status/418")
    state
  end

  defp log(msg) do
    "Sample.Agent[#{inspect(self())}] - " <> msg
  end

  defp get_and_log_status(url) do
    {:ok, %HTTPoison.Response{status_code: status}} = HTTPoison.get(url)
    Logger.info log("status: #{status}")
  end
end
