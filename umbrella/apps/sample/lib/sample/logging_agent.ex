defmodule Sample.LoggingAgent do
  use Whoppex.Agent

  def create_plan(_state) do
    [
      # loop forever on the passed in sub-plan
      forever([
        :ping,
        delay(),
        :pong,
        delay()
      ])
    ]
  end

  def ping(state) do
    Sample.Utils.log("ping")
    state
  end

  def pong(state) do
    Sample.Utils.log("pong")
    state
  end
end
