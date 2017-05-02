defmodule Whoppex.AgentWorker do

  # Behavior for callback modules
  @callback execute(arg :: any) :: any

  use GenServer

  def start_link(agentModule) do
    GenServer.start_link(__MODULE__, agentModule, [])
  end

  def init(agentModule) do
    GenServer.cast(self(), :start)
    {:ok, agentModule}
  end

  def handle_cast(:start, agentModule) do
    {:noreply, agentModule}
  end

end
