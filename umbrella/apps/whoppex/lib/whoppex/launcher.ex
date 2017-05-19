defmodule Whoppex.Launcher do
  require Logger
  use GenServer

  @name Whoppex.Launcher

  def start_link do
    GenServer.start_link(__MODULE__, :nothing, name: @name)
  end

  def init(initial_state) do
    {:ok, initial_state}
  end

end
