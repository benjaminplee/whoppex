defmodule Whoppex.AgentTest do
  use ExUnit.Case, async: true
  alias Whoppex.AgentTest.SampleAgent, as: Agent

  doctest Whoppex.Agent

  @plan [:this, :is, :a, :plan]

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

  test "forever adds tuple with plan" do
    assert {:forever, @plan} == Agent.forever(@plan)
  end

  test "repeat defaults to twice" do
    assert {:repeat, @plan, 2} == Agent.repeat(@plan)
  end

  test "repeat allows for configurable times" do
    assert {:repeat, @plan, 10} == Agent.repeat(@plan, 10)
  end

  test "repeat for period defaults to 30 seconds" do
    assert {:repeat_for_period, @plan, 30000} == Agent.repeat_for_period(@plan)
  end

  test "repeat for period allows for configurable time period" do
    assert {:repeat_for_period, @plan, 1000} == Agent.repeat_for_period(@plan, {1, :second})
  end

  test "repeat for period enforces minimum time period" do
    assert {:repeat_for_period, @plan, 10} == Agent.repeat_for_period(@plan, {1, :millisecond})
  end

  test "delay pauses for normal random distribution around default time using built in randomizer" do
    assert {:pause, ms1} = Agent.delay()
    assert is_integer(ms1)
    assert 10 <= ms1

    # Enforce seeding after first so not to get dupes
    _ = :rand.seed(:exs1024, {123, 123534, 345345})

    assert {:pause, ms2} = Agent.delay({10, :second})
    assert is_integer(ms2)
    assert 10 <= ms2

    assert ms1 !== ms2
  end

  test "delay pauses for random distribution between given min and max" do
    min = 1
    max = {10, :second}

    assert {:pause, ms1} = Agent.delay(min, max)
    assert is_integer(ms1)
    assert 10 <= ms1
    assert min < ms1
    assert max > ms1
    
    # Enforce seeding after first so not to get dupes
    _ = :rand.seed(:exs1024, {123, 123534, 345345})

    assert {:pause, ms2} = Agent.delay(min, max)
    assert is_integer(ms2)
    assert 10 <= ms2
    assert min < ms2
    assert max > ms2

    assert ms1 !== ms2
  end

  test "pause is passthrough with enforcement of min time" do
    assert {:pause, 10} == Agent.pause(1)
    assert {:pause, 1000} == Agent.pause({1, :second})
  end

  defmodule SampleAgent do
    use Whoppex.Agent
  end

  defmodule StubRandomizer do
    def normal do
      0.5
    end

    def uniform(x) do
      x * 10
    end
  end

end

