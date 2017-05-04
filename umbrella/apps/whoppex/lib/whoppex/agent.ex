defmodule Whoppex.Agent do

  # Behavior for callback modules
  @callback create_plan(arg :: any) :: [atom]

  use GenServer
  require Logger

  def start_link(agentModule, agent_state) do
    GenServer.start_link(__MODULE__, {agentModule, agent_state}, [])
  end

  def init({agentModule, agent_state}) do
    Logger.info "Starting Whoppex Agent Worker"
    GenServer.cast(self(), :start)
    {:ok, {agentModule, [], agent_state}}
  end

  def handle_cast(:start, {agentModule, [], agent_state}) do
    plan = agentModule.create_plan(agent_state)
    GenServer.cast(self(), :next)
    {:noreply, {agentModule, plan, agent_state}}
  end

  def handle_cast(:next, {_, [], _} = state) do
    Logger.info("Whoppex Agent Worker Finished #{inspect(state)}")
    {:noreply, state}
  end

  def handle_cast(:next, {agentModule, [next_step | rest_of_the_plan], agent_state}) do
    new_agent_state = apply(agentModule, next_step, [agent_state])
    GenServer.cast(self(), :next)
    {:noreply, {agentModule, rest_of_the_plan, new_agent_state}}
  end

end
