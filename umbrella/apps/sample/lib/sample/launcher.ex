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

  def launch_many(type) do
    GenServer.cast(@name, {:launch_many, type})
  end

  def launch_many_many(type) do
    Enum.each(1..10, fn _ -> GenServer.cast(@name, {:launch_many, type}) end)
  end

  def launch_mix() do
    GenServer.cast(@name, :launch_mix)
  end

  def init(state) do
    Logger.info "Sample Agent Launcher Starting"
    {:ok, state}
  end

  def handle_cast({:launch, type}, state) do
    Whoppex.Supervisor.start_agent_spec(map(type))
    {:noreply, state}
  end

  def handle_cast({:launch_many, type}, state) do
    Whoppex.Supervisor.start_agent_specs(map(type), 10)
    {:noreply, state}
  end

  def handle_cast(:launch_mix, state) do
    Whoppex.Supervisor.start_agent_spec_list(List.flatten([
      {Sample.LoggingAgent, 1..5},
      Enum.map(1..10, fn _ -> map(:http) end),
      Enum.map(1..100, fn _ -> map(:mqtt) end)
    ]))
    {:noreply, state}
  end

  defp map(:logging) do {Sample.LoggingAgent, 1..5} end
  defp map(:http) do {Sample.HttpAgent, "http://httpbin.com"} end
  defp map(:mqtt) do {Sample.MqttAgent, "localhost"} end

end
