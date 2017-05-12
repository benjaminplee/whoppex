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

  def stop_all_agents() do
    Enum.each(Supervisor.which_children(@name), fn x -> stop_agent(x) end)
    :ok
  end

  def init(:ok) do
    max_shutdown_time_in_ms = 5000
    children = [ worker(Whoppex.Worker, [], restart: :transient, shutdown: max_shutdown_time_in_ms) ]
    supervise(children, strategy: :simple_one_for_one)
  end

  defp stop_agent({_child_id, pid, _type, _modules}) when is_pid(pid) do
    GenServer.cast(pid, :shut_down)
  end
end
