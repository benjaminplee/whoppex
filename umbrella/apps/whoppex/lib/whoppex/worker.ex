defmodule Whoppex.Worker do
  require Logger
  use GenServer

  def start_link(agent_spec) do
    GenServer.start_link(__MODULE__, agent_spec, [])
  end

  def init({agent_module, agent_state}) do
    GenServer.cast(self(), :start)
    {:ok, {agent_module, [], agent_module.init(agent_state)}}
  end

  def handle_cast(:start, {agent_module, [], agent_state}) do
    log(agent_module, "STARTING")
    plan = agent_module.create_plan(agent_state)
    GenServer.cast(self(), :next)
    {:noreply, {agent_module, plan, agent_state}}
  end

  def handle_cast(:next, {agent_module, [], _} = state) do
    log(agent_module, "FINISHED")
    {:noreply, state}
  end

  def handle_cast(:next, {agent_module, plan, agent_state}) do
    {next_step, rest_of_the_plan} = parse_plan(plan)
    new_agent_state = apply(agent_module, next_step, [agent_state])
    GenServer.cast(self(), :next)
    {:noreply, {agent_module, rest_of_the_plan, new_agent_state}}
  end

  defp parse_plan([{:forever, steps} | _rest_of_the_plan] = plan) do
    {:noop, [steps | plan]}
  end

  defp parse_plan([{:repeat, _next_step, 0} | rest_of_the_plan]) do
    {:noop, rest_of_the_plan}
  end

  defp parse_plan([{:repeat, next_step, n} | rest_of_the_plan]) do
    {:noop, [next_step | [{:repeat, next_step, n - 1} | rest_of_the_plan]]}
  end

  defp parse_plan([{:pause, ms} | rest_of_the_plan]) do
    Process.sleep(ms)
    {:noop, rest_of_the_plan}
  end

  defp parse_plan([steps | rest_of_the_plan]) when is_list(steps) do
    {:noop, steps ++ rest_of_the_plan}
  end

  defp parse_plan([next_step | rest_of_the_plan]) do
    {next_step, rest_of_the_plan}
  end

  defp log(agent_module, msg) do
    Logger.info("WorkerAgent[#{agent_module}:#{inspect(self())}] - #{msg}")
  end
end
