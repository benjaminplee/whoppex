defmodule Whoppex.Agent do

  # Behavior for callback modules
  @callback init(arg :: any) :: any
  @callback create_plan(arg :: any) :: [atom]

  defmacro __using__(_) do
    quote location: :keep do
      @behaviour Whoppex.Agent

      def init(state) do
        state
      end

      def id(state) do
        inspect(self())
      end

      def create_plan(_state) do
        [:noop]
      end

      def forever(plan) do
        {:forever, plan}
      end

      def repeat(plan, times \\ 2) do
        {:repeat, plan, times}
      end

      def delay(time \\ {1, :second}) do
        ms = enforce_ms(time)
        {:pause, enforce_min_time(round(:rand.normal() * ms))}
      end

      def delay(min_time, max_time) do
        min_ms = enforce_ms(min_time)
        max_ms = enforce_ms(max_time)
        {:pause, enforce_min_time(:rand.uniform(max_ms - min_ms) + min_ms)}
      end

      def pause(time \\ {1, :second}) do
        ms = enforce_ms(time)
        {:pause, enforce_min_time(ms)}
      end

      def noop(state) do
        state
      end

      defp enforce_min_time(ms) do
        max(10, ms)
      end

      defp enforce_ms({value, unit}) do System.convert_time_unit(value, unit, :millisecond) end
      defp enforce_ms(value) do value end

      defoverridable [init: 1, create_plan: 1]
    end
  end
end
