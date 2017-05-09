defmodule Sample.LoggingAgent do
  use Whoppex.Agent
  require Logger

  def create_plan(enumerable_state) do
    Logger.info log("Reporting For Duty")
    [
      Enum.map(enumerable_state, fn _ -> [:say_hello, delay()] end),
      forever([           # loop forever on the passed in sub-plan
        :ping,
        delay()
      ])
    ]
  end

  def say_hello(state) do
    Logger.info log("hello world")
    state
  end

  def ping(state) do
    Logger.info log("pong")
    state
  end

  defp log(msg) do
    "Sample.Agent[#{inspect(self())}] - " <> msg
  end

end
