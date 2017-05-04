defmodule Whoppex.Supervisor do
  use Supervisor

  @name Whoppex.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_agent(agent_module, agent_state) do
    Supervisor.start_child(@name, [agent_module, agent_state])
  end

  def init(:ok) do
    children = [ worker(Whoppex.Worker, [], restart: :temporary) ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
