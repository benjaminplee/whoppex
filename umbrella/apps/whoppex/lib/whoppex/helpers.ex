defmodule Whoppex.Helpers do
  def enforce_ms({value, unit}) do System.convert_time_unit(value, unit, :millisecond) end
  def enforce_ms(value) do value end

  defp enforce_min_time(ms) do max(@min_ms, ms) end
end
