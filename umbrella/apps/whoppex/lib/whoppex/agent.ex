defmodule Whoppex.Agent do

  # Behavior for callback modules
  @callback execute(arg :: any) :: any

  use GenServer
  require Logger

  def start_link(agentModule) do
    GenServer.start_link(__MODULE__, agentModule, [])
  end

  def init(agentModule) do
    Logger.info "Starting Whoppex Agent Worker"
    GenServer.cast(self(), :start)
    {:ok, {agentModule, :sample}}
  end

  def handle_cast(:start, {agentModule, agent_state}) do
    new_agent_state = agentModule.execute(agent_state)
    {:noreply, {agentModule, new_agent_state}}
  end

end
