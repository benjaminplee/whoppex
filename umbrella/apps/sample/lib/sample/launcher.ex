defmodule Sample.Launcher do
  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(state) do
    Logger.info "Sample Agent Launcher Starting"
    GenServer.cast(self(), :launch)
    {:ok, state}
  end

  def handle_cast(:launch, state) do
    Whoppex.Supervisor.start_agent(Sample.Agent)
    {:noreply, state}
  end


end
