defmodule Whoppex.Launcher do
  require Logger
  use GenServer
  import Whoppex.Helpers

  @name Whoppex.Launcher

  def start_link do
    GenServer.start_link(__MODULE__, :nothing, name: @name)
  end

  def init(initial_state) do
    {:ok, initial_state}
  end

  def launch_agent(agent_module, initial_state, delay // {0, milliseconds}0) do
    delay_ms = enforce_min_time(enforce_ms(delay), 0)
    launch(agent_module, initial_state, delay_ms) 
  end

  def launch_agents(agent_module, initial_state, n, delay // {0, milliseconds}) do
    delay_ms = enforce_min_time(enforce_ms(delay), 0)
    Stream.each(1..n, fn _ -> launch(agent_module, initial_state, delay_ms) end)
  end

  def launch_agents_over(agent_module, initial_state, n, period // {30, seconds}) do
    period_ms = enforce_min_time(enforce_ms(period), n)
    delay_ms = trunc(period_ms / n)
  
    launch_agents(agent_module, initial_state, n, delay_ms)
  end

  defp launch(agent_module, initial_state, 0) do
    GenServer.cast(@name, {:launch, %Whoppex.AgentSpec{module: agent_module, initial_state: initial_state}})
    :ok
  end

  defp launch(agent_module, initial_state, delay) do
    {:ok, _} = :timer.apply_after(delay, GenServer, :cast, [@name, %Whoppex.AgentSpec{module: agent_module, initial_state: initial_state}])
    :ok
  end

end
