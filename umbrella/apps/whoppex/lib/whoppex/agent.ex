defmodule Whoppex.Agent do

  # Behavior for callback modules
  @callback create_plan(arg :: any) :: [atom]

  defmacro __using__(_) do
    quote location: :keep do
      @behaviour Whoppex.Agent

      def repeat(plan, times \\ 2) do
        {:repeat, plan, times}
      end

      def pause(min \\ 1000, max \\ 1000) when min <= max do
        {:pause, min, max}
      end

      def noop(state) do
        state
      end

      #defoverridable [init: 1]
    end
  end
end
