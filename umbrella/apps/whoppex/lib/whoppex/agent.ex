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

      def delay(ms \\ 1000) do
        {:pause, enforce_min_time(round(:rand.normal() * ms))}
      end

      def delay(min_ms, max_ms) when min_ms <= max_ms do
        {:pause, enforce_min_time(:rand.uniform(max_ms - min_ms) + min_ms)}
      end

      def pause(ms \\ 1000) do
        {:pause, enforce_min_time(ms)}
      end

      def noop(state) do
        state
      end

      defp enforce_min_time(ms) do
        max(10, ms)
      end

      defoverridable [init: 1, create_plan: 1]
    end
  end
end
