defmodule WhoppexAgents do
	use Application

	def start(_type, args) do
		WhoppexAggents.Supervisor.start_link
	end
end

