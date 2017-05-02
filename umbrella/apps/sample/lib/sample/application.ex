defmodule Sample.Application do
  use Application

  def start(_type, _args) do
    Sample.Launcher.start_link()
  end
end
