defmodule Whoppex.AgentSupervisor do
  use Supervisor

  @name Whoppex.AgentSupervisor

  #### API ####

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def launch(agent_spec, start_delay_ms) do
    Supervisor.start_child(@name, [agent_spec, start_delay_ms])
  end

  def stop_all() do
    living_agent_pids() |> Enum.each(fn pid -> GenServer.cast(pid, :shut_down) end)
    :ok
  end 

  @spec num_agents() :: integer
  def num_agents() do
    living_agent_pids() |> Enum.count()
  end

  #### CALLBACKS ####

  def init(:ok) do
    max_shutdown_time_in_ms = 5000
    children = [ worker(Whoppex.Worker, [], restart: :transient, shutdown: max_shutdown_time_in_ms) ]
    supervise(children, strategy: :simple_one_for_one)
  end

  #### PRIVATE ####

  defp living_agent_pids() do
    for {_, pid, _, _} <- Supervisor.which_children(@name), is_pid(pid), do: pid
  end

end
