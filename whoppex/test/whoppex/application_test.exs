defmodule Whoppex.ApplicationTest do
  use ExUnit.Case, async: true
  import Whoppex.Utils

  doctest Whoppex.Application

  test "Is an Application" do
    assert implements?(Whoppex.Application, Application)
  end

  test "App is started clean" do
    assert app_started? :whoppex
  end
end
