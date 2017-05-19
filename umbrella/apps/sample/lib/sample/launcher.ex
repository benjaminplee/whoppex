defmodule Sample.Launcher do
  use GenServer
  require Logger

  @name Sample.Launcher

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def launch(type) do
    GenServer.cast(@name, {:launch, type})
  end

  def launch_many(type, n \\ 10) do
    GenServer.cast(@name, {:launch_many, type, n})
  end

  def launch_mix() do
    GenServer.cast(@name, :launch_mix)
  end

  def init(state) do
    Logger.info "Sample Agent Launcher Starting"
    {:ok, state}
  end

  def handle_cast({:launch, type}, state) do
    Whoppex.AgentSupervisor.start_agent_spec(map(type))
    {:noreply, state}
  end

  def handle_cast({:launch_many, type, n}, state) do
    Whoppex.AgentSupervisor.start_agent_specs(map(type), n)
    {:noreply, state}
  end

  def handle_cast(:launch_mix, state) do
    Whoppex.AgentSupervisor.start_agent_spec_list(List.flatten([
      {Sample.LoggingAgent, 1..5},
      Enum.map(1..10, fn _ -> map(:http) end),
      Enum.map(1..100, fn _ -> map(:mqtt) end)
    ]))
    {:noreply, state}
  end

  defp map(:logging) do {Sample.LoggingAgent, 1..5} end
  defp map(:http) do {Sample.HttpAgent, "https://httpbin.org"} end
  defp map(:mqtt) do {Sample.MqttAgent, "localhost"} end

end
