defmodule Sample.Agent do
  @behaviour Whoppex.Agent

  def execute(state) do
    IO.puts "Sample.Agent (#{self()}) reporting for duty"
    state
  end
end
