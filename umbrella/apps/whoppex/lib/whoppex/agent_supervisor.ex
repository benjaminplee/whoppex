defmodule Whoppex.AgentSupervisor do
  use Supervisor

  @name Whoppex.AgentSupervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  @spec start_agent_spec(Whoppex.Worker.agent_spec) :: :ok
  def start_agent_spec(agent_spec) do
    start_agent_specs(agent_spec, 1)
  end

  def start_agent_specs(_agent_spec, 0) do
    :ok
  end

  @spec start_agent_specs(Whoppex.Worker.agent_spec, integer) :: :ok
  def start_agent_specs(agent_spec, n) do
    Supervisor.start_child(@name, [agent_spec])
    start_agent_specs(agent_spec, n - 1)
  end

  @spec start_agent_spec_list([Whoppex.Worker.agent_spec]) :: :ok
  def start_agent_spec_list([]) do
    :ok
  end

  @spec start_agent_spec_list([Whoppex.Worker.agent_spec]) :: :ok
  def start_agent_spec_list([agent_spec | rest]) do
    start_agent_spec(agent_spec)
    start_agent_spec_list(rest)
  end

  @spec stop_all_agents() :: :ok
  def stop_all_agents() do
    living_agent_pids() |> Enum.each(fn pid -> GenServer.cast(pid, :shut_down) end)
    :ok
  end

  @spec num_agents() :: integer
  def num_agents() do
    living_agent_pids() |> Enum.count()
  end

  def init(:ok) do
    max_shutdown_time_in_ms = 5000
    children = [ worker(Whoppex.Worker, [], restart: :transient, shutdown: max_shutdown_time_in_ms) ]
    supervise(children, strategy: :simple_one_for_one)
  end

  defp living_agent_pids() do
    for {_, pid, _, _} <- Supervisor.which_children(@name), is_pid(pid), do: pid
  end
end
