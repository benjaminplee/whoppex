defmodule Whoppex.Application do
  use Application
  require Logger

  def start(_type, _args) do
    Logger.info "Starting Whoppex Application"
    Whoppex.Supervisor.start_link
  end
end
