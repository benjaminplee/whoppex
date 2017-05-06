defmodule Sample.Launcher do
  use GenServer
  require Logger

  @name Sample.Launcher

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def launch() do
    GenServer.cast(@name, :launch)
  end

  def launch_many() do
    GenServer.cast(@name, :launch_many)
  end

  def launch_many_types() do
    GenServer.cast(@name, :launch_many_types)
  end

  def init(state) do
    Logger.info "Sample Agent Launcher Starting"
    {:ok, state}
  end

  def handle_cast(:launch, state) do
    Whoppex.Supervisor.start_agent_spec({Sample.HttpAgent, :no_state})
    {:noreply, state}
  end

  def handle_cast(:launch_many, state) do
    Whoppex.Supervisor.start_agent_specs({Sample.HttpAgent, :no_state}, 10)
    {:noreply, state}
  end

  def handle_cast(:launch_many_types, state) do
    Whoppex.Supervisor.start_agent_spec_list([{Sample.HttpAgent, :no_state}, {Sample.LoggingAgent, 1..5}])
    {:noreply, state}
  end

end
