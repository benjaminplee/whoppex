defmodule Whoppex.Supervisor do
  use Supervisor

  @name Whoppex.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_agent(agentModule) do
    Supervisor.start_child(@name, [agentModule])
  end

  def init(:ok) do
    children = [ worker(Whoppex.AgentWorker, [], restart: :temporary) ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
