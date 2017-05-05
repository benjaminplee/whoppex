defmodule Whoppex.Agent do

  # Behavior for callback modules
  @callback create_plan(arg :: any) :: [atom]

  defmacro __using__(_) do
    quote location: :keep do
      @behaviour Whoppex.Agent
      @default_pause 1000

      def repeat(function_name, times) do
        {:repeat, function_name, times}
      end

      def pause(min \\ @default_pause, max \\ @default_pause) when min <= max do
        {:pause, min, max}
      end

      def noop(state) do
        state
      end

      #defoverridable [init: 1]
    end
  end
end
