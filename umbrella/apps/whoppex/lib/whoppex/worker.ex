defmodule Whoppex.Worker do
  use GenServer
  require Logger

  def start_link(agent_module, agent_state) do
    GenServer.start_link(__MODULE__, {agent_module, agent_state}, [])
  end

  def init({agent_module, agent_state}) do
    Logger.info "Starting Whoppex Agent Worker"
    GenServer.cast(self(), :start)
    {:ok, {agent_module, [], agent_state}}
  end

  def handle_cast(:start, {agent_module, [], agent_state}) do
    plan = agent_module.create_plan(agent_state)
    GenServer.cast(self(), :next)
    {:noreply, {agent_module, plan, agent_state}}
  end

  def handle_cast(:next, {_, [], _} = state) do
    Logger.info("Whoppex Agent Worker Finished #{inspect(state)}")
    {:noreply, state}
  end

  def handle_cast(:next, {agent_module, plan, agent_state}) do
    {next_step, rest_of_the_plan} = parse_plan(plan)
    new_agent_state = apply(agent_module, next_step, [agent_state])
    GenServer.cast(self(), :next)
    {:noreply, {agent_module, rest_of_the_plan, new_agent_state}}
  end

  defp parse_plan([{:repeat, _next_step, 0} | rest_of_the_plan]) do
    {:noop, rest_of_the_plan}
  end

  defp parse_plan([{:repeat, next_step, n} | rest_of_the_plan]) do
    {:noop, [next_step | [{:repeat, next_step, n - 1} | rest_of_the_plan]]}
  end

  defp parse_plan([{:pause, min, max} | rest_of_the_plan]) do
    pause_proc(min, max)
    {:noop, rest_of_the_plan}
  end

  defp parse_plan([steps | rest_of_the_plan]) when is_list(steps) do
    {:noop, steps ++ rest_of_the_plan}
  end

  defp parse_plan([next_step | rest_of_the_plan]) do
    {next_step, rest_of_the_plan}
  end

  defp pause_proc(min, min) do
    Process.sleep(min)
  end

  defp pause_proc(min, max) do
    time = :rand.uniform(max - min) + min
    Process.sleep(time)
  end
end
