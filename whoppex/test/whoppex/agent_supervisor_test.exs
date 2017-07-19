defmodule Whoppex.AgentSupervisorTest do
  use ExUnit.Case
  import Whoppex.Utils
  alias Whoppex.AgentSupervisor, as: TM

  doctest Whoppex.AgentSupervisor

  setup do
    # TODO get rid of this echo-chamber
    # TODO this, and calls below, are non-deterministic due to casts for shutdown unlike start_links which happen in blocking calls
    TM.stop_all_agents()
  end

  test "implements behavior" do
    assert implements?(TM, Supervisor)
  end

  test "starts without any children" do
    assert 0 == TM.num_agents()
  end

#  test "starts worker with agent_spec" do
#    spec = {Whoppex.SupervisorTest.TestAgent, :none}
#    TM.start_agent_spec(spec) 
#    assert 1 == TM.num_agents()
#  end
#
#  test "stops_all_agents" do
#    TM.start_agent_spec({Whoppex.SupervisorTest.TestAgent, :none}) 
#    assert 1 == TM.num_agents()
#    TM.stop_all_agents()
#    assert 0 == TM.num_agents()
#  end

  # TODO Test the rest of the supervisor methods

  defmodule TestAgent do
    use Whoppex.Agent
  end

end
