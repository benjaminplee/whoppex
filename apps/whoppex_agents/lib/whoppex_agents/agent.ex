defmodule WA.Agent do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(:ok) do
    GenServer.cast(self(), :go)
    {:ok, :no_state}
  end

  def handle_cast(:go, _state) do
    IO.puts "hello"
    {:noreply, :no_state}
  end

end
