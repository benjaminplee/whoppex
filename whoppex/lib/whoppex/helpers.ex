defmodule Whoppex.Helpers do
  def enforce_ms({value, unit}) do System.convert_time_unit(value, unit, :millisecond) end
  def enforce_ms(value) do value end

  def enforce_min_time(ms, min_ms) do max(ms, min_ms) end
end
