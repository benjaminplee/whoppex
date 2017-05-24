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
    Whoppex.Commander.launch_agent(map(type))
    {:noreply, state}
  end

  def handle_cast({:launch_many, type, n}, state) do
    Whoppex.Commander.launch_agents_every(map(type), n, {5, :seconds})
    {:noreply, state}
  end

  def handle_cast(:launch_mix, state) do
    Whoppex.Commander.launch_mix_over(List.flatten([
      map(:logging),
      Enum.map(1..10, fn _ -> map(:http) end),
      Enum.map(1..100, fn _ -> map(:mqtt) end)
    ]))
    {:noreply, state}
  end

  defp map(:logging) do %Whoppex.Agent{module: Sample.LoggingAgent, state: 1..5} end
  defp map(:http) do %Whoppex.Agent{module: Sample.HttpAgent, state: "https://httpbin.org"} end
  defp map(:mqtt) do %Whoppex.Agent{module: Sample.MqttAgent, state: "localhost"} end

end
