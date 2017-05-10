defmodule Sample.Utils do
  require Logger

  def rnd_id() do
    id_length = 5
    possible_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" |> String.split("", trim: true)

    1..id_length
      |> Enum.reduce([], fn(_, acc) -> [Enum.random(possible_chars) | acc] end)
      |> Enum.join("")
  end

  def log(msg) do
    log(inspect(self()), msg)
  end

  def log(agent_id, msg) do
    Logger.info("Agent[#{agent_id}] - #{msg}")
  end
end
