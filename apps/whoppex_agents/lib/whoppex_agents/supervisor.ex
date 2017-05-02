defmodule WA.Supervisor do
  use Supervisor

  @name WA.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_agent do
    Supervisor.start_child(@name, [])
  end

  def init(:ok) do
    children = [ worker(WA.Agent, [], restart: :temporary) ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
