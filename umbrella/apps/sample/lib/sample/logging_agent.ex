defmodule Sample.LoggingAgent do
  use Whoppex.Agent

  def create_plan(_state) do
    [
      # loop forever on the passed in sub-plan
      forever([
        :ping,
        pause(500),
        :pong,
        pause(500)
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
