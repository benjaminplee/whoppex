defmodule Sample.Agent do
  @behaviour Whoppex.Agent
  require Logger

  @sample_url "https://httpbin.org/ip"

  def create_plan(_state) do
    Logger.info log("Reporting For Duty")
    [:get_ip]
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
