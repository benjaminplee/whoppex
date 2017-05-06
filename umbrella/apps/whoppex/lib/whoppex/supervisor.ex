defmodule Whoppex.Supervisor do
  use Supervisor

  @name Whoppex.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_agent_spec(agent_spec) do
    start_agent_specs(agent_spec, 1)
  end

  def start_agent_specs(_agent_spec, 0) do
    :ok
  end

  def start_agent_specs(agent_spec, n) do
    Supervisor.start_child(@name, [agent_spec])
    start_agent_specs(agent_spec, n - 1)
  end

  def start_agent_spec_list([]) do
    :ok
  end

  def start_agent_spec_list([agent_spec | rest]) do
    start_agent_spec(agent_spec)
    start_agent_spec_list(rest)
  end

  def init(:ok) do
    children = [ worker(Whoppex.Worker, [], restart: :temporary) ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
