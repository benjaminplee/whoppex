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

  def launch_many_over(type, time, n \\ 10) do
    GenServer.cast(@name, {:launch_many_over, type, time, n})
  end

  def launch_many_every(type, time, n \\ 10) do
    GenServer.cast(@name, {:launch_many_every, type, time, n})
  end

  def launch_mix() do
    GenServer.cast(@name, :launch_mix)
  end

  def launch_mix_over(time \\ {10, :seconds}) do
    GenServer.cast(@name, {:launch_mix_over, time})
  end

  def launch_mix_every(time \\ {2, :seconds}) do
    GenServer.cast(@name, {:launch_mix_every, time})
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
    Whoppex.Commander.launch_agents_every(n, map(type), {1, :seconds})
    {:noreply, state}
  end

  def handle_cast({:launch_many_over, type, time, n}, state) do
    Whoppex.Commander.launch_agents_over(n, map(type), time)
    {:noreply, state}
  end

  def handle_cast({:launch_many_every, type, time, n}, state) do
    Whoppex.Commander.launch_agents_every(n, map(type), time)
    {:noreply, state}
  end

  def handle_cast(:launch_mix, state) do
    Whoppex.Commander.launch_mix_over(create_mix())
    {:noreply, state}
  end

  def handle_cast({:launch_mix_over, time}, state) do
    Whoppex.Commander.launch_mix_over(create_mix(), time)
    {:noreply, state}
  end

  def handle_cast({:launch_mix_every, time}, state) do
    Whoppex.Commander.launch_mix_every(create_mix(), time)
    {:noreply, state}
  end

  defp create_mix() do
    List.flatten([
      map(:logging),
      Enum.map(1..10, fn _ -> map(:http) end),
      Enum.map(1..100, fn _ -> map(:mqtt) end)
    ])
  end

  defp map(:logging) do %Whoppex.Agent{module: Sample.LoggingAgent, state: 1..5} end
  defp map(:http) do %Whoppex.Agent{module: Sample.HttpAgent, state: "https://httpbin.org"} end
  defp map(:mqtt) do %Whoppex.Agent{module: Sample.MqttAgent, state: "localhost"} end
  defp map(:pick) do %Whoppex.Agent{module: Sample.PickTheIconAgent, state: :ignored} end

end
