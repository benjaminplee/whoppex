defmodule Whoppex.SampleAgent do
  use Whoppex.Agent
end

defmodule Whoppex.AgentTest do
  use ExUnit.Case, async: true
  alias Whoppex.SampleAgent, as: Agent

  doctest Whoppex.Agent

  test "default init is a passthrough" do
    assert :foo == Agent.init(:foo)
  end

  test "default id uses pid" do
    pid = inspect(self())
    assert pid == Agent.id(:anything)
  end

  test "default create_plan is noop" do
    assert [:noop] == Agent.create_plan(:anything)
  end

end

