defmodule Sample.MqttAgent do
  use Whoppex.Agent
  require Logger

  def create_plan(_id) do
    Logger.info log("Reporting For Duty")
    [:setup_state, :connect, repeat([:publish, pause()], 10), :clean_up]
  end

  def setup_state(id) do
    {:ok, client_pid} = Sample.MqttAgent.MqttClient.start_link(%{})
    {id, [client_id: id, host: "localhost", port: 1883, keep_alive: 600], client_pid}
  end

  def connect({_id, options, client_pid} = state) do
    :ok = Sample.MqttAgent.MqttClient.connect(client_pid, options)
    state
  end

  def publish({id, options, client_pid} = state) do
    :ok = Sample.MqttAgent.MqttClient.publish(client_pid, pub_msg(options, "whoppex/sample", "hello from " <> id)) 
    state
  end

  def clean_up({_id, _options, client_pid} = state) do
    :ok = Sample.MqttAgent.MqttClient.disconnect(client_pid)
    state
  end

  defp log(msg) do
    "Sample.Agent[#{inspect(self())}] - " <> msg
  end

  defp pub_msg(options, topic, message) do
    Keyword.merge(options, [message: message, topic: topic, dup: 0, qos: 0, retain: 0])
  end

  defmodule MqttClient do
    use Hulaaki.Client
#
#    def on_connect_ack(options) do
#      IO.inspect options
#    end
#
#    def on_subscribed_publish(options) do
#      IO.inspect options
#    end
#
#    def on_subscribe_ack(options) do
#      IO.inspect options
#    end
#
#    def on_pong(options) do
#      IO.inspect options
#    end 
  end
end

