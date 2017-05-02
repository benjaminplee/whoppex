defmodule Sample.Application do
  use Application
  require Logger

  def start(_type, _args) do
    Logger.info "Starting Sample Whoppex Application"
    Sample.Launcher.start_link()
  end
end
