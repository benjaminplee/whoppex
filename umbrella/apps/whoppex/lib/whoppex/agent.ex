defmodule Whoppex.Agent do

  # Behavior for callback modules
  @callback create_plan(arg :: any) :: [atom]

  defmacro __using__(_) do
    quote location: :keep do
      @behaviour Whoppex.Agent

      def repeat(function_name, times) do
        {:repeat, function_name, times}
      end

      #defoverridable [init: 1]
    end
  end
end
