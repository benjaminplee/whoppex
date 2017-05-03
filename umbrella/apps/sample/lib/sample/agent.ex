defmodule Sample.Agent do
  @behaviour Whoppex.Agent
  require Logger

  @sample_url "https://httpbin.org/ip"

  def execute(state) do
    self = inspect(self())
    Logger.info "Sample.Agent (#{self}) reporting for duty"
    {:ok, %HTTPoison.Response{status_code: status}} = HTTPoison.get(@sample_url)
    Logger.info "Sample.Agent (#{self}) got response status: #{status}"
    state
  end
end
