defmodule Sample.Agent do
  use Whoppex.Agent
  require Logger

  @sample_url "http://httpbin.org/ip"

  def create_plan(_state) do
    Logger.info log("Reporting For Duty")
    [:say_hello, repeat(:get_ip, 10), :say_goodbye]
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
    {:ok, %HTTPoison.Response{status_code: status}} = HTTPoison.get(@sample_url)
    Logger.info log("status: #{status}")
    state
  end

  defp log(msg) do
    "Sample.Agent[#{inspect(self())}] - " <> msg
  end
end
