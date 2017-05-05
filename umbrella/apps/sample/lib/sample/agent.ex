defmodule Sample.Agent do
  use Whoppex.Agent
  require Logger

  def create_plan(_state) do
    Logger.info log("Reporting For Duty")
    [
      :say_hello,
      pause(),
      repeat(:get_ip),
      pause(),
      repeat([
        :get_teapot,
        pause()
      ], 3),
      pause(2000, 4000),
      :say_goodbye
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
