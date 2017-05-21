defmodule Whoppex.AgentSupervisor do
  use Supervisor

  @name Whoppex.AgentSupervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  @spec launch(%Whoppex.Agent{}, non_neg_integer) :: Supervisor.on_start_child
  def launch(agent_spec, start_delay_ms) do
    Supervisor.start_child(@name, [agent_spec, start_delay_ms])
  end

  @spec stop_all() :: :ok
  def stop_all(matching_fun) do
    #living_agent_pids() |> Enum.each(fn pid -> GenServer.cast(pid, :shut_down) end)
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
