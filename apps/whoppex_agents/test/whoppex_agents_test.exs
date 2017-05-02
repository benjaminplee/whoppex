defmodule ApplicationTest do
  use ExUnit.Case
  doctest WA.Application

  test "start creates supervisor" do
    Application.stop(:whoppex_agents)
    {:ok, pid} = WA.Application.start(:something, :somethingElse)
    assert [] == Supervisor.which_children(pid)
  end
end
