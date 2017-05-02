defmodule Sample.Agent do
  @behaviour Whoppex.Agent
  require Logger

  def execute(state) do
    self = inspect(self())
    Logger.info "Sample.Agent (#{self}) reporting for duty"
    state
  end
end
