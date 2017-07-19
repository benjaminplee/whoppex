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
  def launch_agent(spec, delay \\ {0, :milliseconds}) do
    launch_agents_every(1, spec, delay)
  end

  @spec launch_agents_every(non_neg_integer, %Whoppex.Agent{}, System.time_unit) :: :ok
  def launch_agents_every(n, spec, delay \\ {0, :milliseconds}) do
    delay_ms = enforce_min_time(enforce_ms(delay), 0)

    launch(n, spec, delay_ms)
    :ok
  end

  @spec launch_agents_over(non_neg_integer, %Whoppex.Agent{}, System.time_unit) :: :ok
  def launch_agents_over(n, spec, period \\ {30, :seconds}) do
    period_ms = enforce_min_time(enforce_ms(period), n)
    delay_ms = trunc(period_ms / n)
  
    launch(n, spec, delay_ms)
    :ok
  end

  @spec launch_mix_every([%Whoppex.Agent{}], System.time_unit) :: :ok
  def launch_mix_every(specs, delay \\ {0, :milliseconds}) do
    delay_ms = enforce_min_time(enforce_ms(delay), 0)
    launch(specs, delay_ms)
    :ok
  end

  @spec launch_mix_over([%Whoppex.Agent{}], System.time_unit) :: :ok
  def launch_mix_over(specs, period \\ {30, :seconds}) do
    period_ms = enforce_min_time(enforce_ms(period), 0)
    delay_ms = trunc(period_ms / length(specs))
    
    launch(specs, delay_ms)
    :ok
  end

  def stop_all() do
    GenServer.cast(@name, :stop_all)
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
    Enum.each(1..n, fn i -> Whoppex.AgentSupervisor.launch(spec, delay_ms * (i - 1)) end)
    {:noreply, state}
  end

  def handle_cast({:launch, specs, delay_ms}, state) do
    Enum.with_index(specs) |> Enum.each(fn {spec, i} -> Whoppex.AgentSupervisor.launch(spec, delay_ms * (i - 1)) end)
    {:noreply, state}
  end

  def handle_cast(:stop_all, state) do
    Whoppex.AgentSupervisor.stop_all()
    {:noreply, state}
  end

end
