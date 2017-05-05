defmodule Whoppex.Supervisor do
  use Supervisor

  @name Whoppex.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_agent(agent_module, agent_state) do
    start_agents(agent_module, agent_state, 1)
  end

  def start_agents(agent_module, agent_state, 0) do
    :ok
  end

  def start_agents(agent_module, agent_state, n) do
    Supervisor.start_child(@name, [agent_module, agent_state])
    start_agents(agent_module, agent_state, n - 1)
  end

  def init(:ok) do
    children = [ worker(Whoppex.Worker, [], restart: :temporary) ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
