defmodule WA.Application do
  use Application

  def start(_type, _args) do
    WA.Supervisor.start_link
  end
end
