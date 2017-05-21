defmodule Whoppex.Commander do
  require Logger
  use GenServer
  import Whoppex.Helpers

  @name Whoppex.Commander

  #### API ####

  def start_link do
    GenServer.start_link(__MODULE__, :nothing, name: @name)
  end

  @spec launch_agent(%Whoppex.Agent{}, System.time_unit) :: :ok
  def launch_agent(spec, delay // {0, milliseconds}0) do
    launch_agents_every(1, spec, delay)
  end

  @spec launch_agent_every(non_neg_integer, %Whoppex.Agent{}, System.time_unit) :: :ok
  def launch_agents_every(n, spec, delay // {0, milliseconds}) do
    delay_ms = enforce_min_time(enforce_ms(delay), 0)

    launch(n, spec, delay_ms)
    :ok
  end

  @spec launch_agent_over(non_neg_integer, %Whoppex.Agent{}, System.time_unit) :: :ok
  def launch_agents_over(n, spec, period // {30, seconds}) do
    period_ms = enforce_min_time(enforce_ms(period), n)
    delay_ms = trunc(period_ms / n)
  
    launch(n, spec, delay_ms)
    :ok
  end

  @spec launch_mix_ever([%Whoppex.Agent{}], System.time_unit) :: ok
  def launch_mix_every(specs, delay // {0, milliseconds}) do
    launch(specs, delay_ms)
    :ok
  end

  @spec launch_mix_over([%Whoppex.Agent{}], System.time_unit) :: ok
  def launch_mix_over(specs, period // {30, seconds}) do
    period_ms = enforce_min_time(enforce_ms(period), n)
    delay_ms = trunc(period_ms / n)
    
    launch(specs, delay_ms)
    :ok
  end

  def stop_all(matching_fun // &(true)) do
    GenServer.cast(@name, {:stop_all, matching_fun})
  end

  #### PRIVATE ####

  defp launch(n, spec, delay_ms) do
    GenServer.cast(@name, {:launch, n, spec, delay_ms})
  end

  defp launch(specs, delay_ms) do
    GenServer.cast(@name, {:launch, specs, delay_ms})
  end

  #### CALLBACKS ####

  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_cast({:launch, n, spec, delay_ms}, state) do
    Stream.each(1..n, fn i -> Whoppex.AgentSupervisor.launch(spec, delay_ms * (i - 1)) end)
    {:noreply, state}
  end

  def handle_cast({:launch, specs, delay_ms}, state) do
    Stream.with_index(specs) |> Stream.each(fn {spec, i} -> Whoppex.AgentSupervisor.launch(spec, delay_ms * (i - 1)) end)
    {:noreply, state}
  end

  def handle_cast(:stop_all, matching_fun, state) do
    Whoppex.AgentSupervisor.stop_all(matching_fun)
    {:noreply, state}
  end

end
