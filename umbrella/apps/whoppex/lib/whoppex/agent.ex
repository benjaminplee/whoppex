defmodule Whoppex.Agent do

  # Behavior for callback modules
  @callback init(arg :: any) :: any
  @callback create_plan(arg :: any) :: [atom]

  defmacro __using__(_) do
    quote location: :keep do
      import Whoppex.Helpers
      @behaviour Whoppex.Agent

      @min_ms 10

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

      def repeat_for_period(plan, time \\ {30, :second}) do
        period_ms = enforce_min_time(enforce_ms(time))
        {:repeat_for_period, plan, period_ms}
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

      defoverridable [init: 1, create_plan: 1]
    end
  end
end

defmodule Whoppex.Agent.ForeverNoOpAgent do
  use Whoppex.Agent

  def create_plan(_) do
    [forever(:noop)]
  end

end
