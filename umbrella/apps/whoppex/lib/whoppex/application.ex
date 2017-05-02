defmodule Whoppex.Application do
  use Application

  def start(_type, _args) do
    Whoppex.Supervisor.start_link
  end
end
