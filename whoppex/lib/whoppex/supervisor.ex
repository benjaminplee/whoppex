defmodule Whoppex.Supervisor do
  use Supervisor

  @name Whoppex.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(_) do
    children = [
      supervisor(Whoppex.AgentSupervisor, [], restart: :permanent, shutdown: 5000),
      worker(Whoppex.Commander, [], restart: :permanent, shutdown: 5000)
    ]

    supervise(children, strategy: :one_for_one)
  end
end
