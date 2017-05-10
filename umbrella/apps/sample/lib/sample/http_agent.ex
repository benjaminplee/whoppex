defmodule Sample.HttpAgent do
  use Whoppex.Agent

  def create_plan(_host) do
    [
      :say_hello,         # execute function as step
      delay(),            # use default delay with normal dist randomization
      repeat(:get_ip),    # repeat specific step (function name atom) default times
      delay({2, :second}),        # use specific delay (in ms) with normal dist
      repeat([            # repeat the sub-plan 3 times
        :get_teapot,
        pause()           # wait for specific time (no random) using default
      ], 3),
      delay({2, :second}, {4, :second}),  # wait for between min and max ms
      :say_goodbye
    ]
  end

  def say_hello(host) do
    Sample.Utils.log("Hello World!")
    host
  end

  def say_goodbye(host) do
    Sample.Utils.log("Bye Bye")
    host
  end

  def get_ip(host) do
    get_and_log_status(host <> "/ip")
    host
  end

  def get_teapot(host) do
    get_and_log_status(host <> "/status/418")
    host
  end

  defp get_and_log_status(url) do
    {:ok, %HTTPoison.Response{status_code: status}} = HTTPoison.get(url)
    Sample.Utils.log("HTTPRESPONSE - #{url} - #{status}")
  end
end
