defmodule Sample.MqttAgent do
  use Whoppex.Agent

  def init(host) do
    id = Sample.Utils.rnd_id()
    {:ok, client_pid} = Sample.MqttAgent.MqttClient.start_link(%{})
    {id, [client_id: id, host: host, port: 1883, keep_alive: 600], client_pid}
  end

  def create_plan(_state) do
    [:connect, repeat([:publish, pause()], 10), :disconnect]
  end

  def connect({id, options, client_pid} = state) do
    Sample.Utils.log(id, "MQTT CONNECT")
    :ok = Sample.MqttAgent.MqttClient.connect(client_pid, options)
    state
  end

  def publish({id, options, client_pid} = state) do
    :ok = Sample.MqttAgent.MqttClient.publish(client_pid, pub_msg(options, "whoppex/sample", "hello from #{id}")) 
    state
  end

  def disconnect({id, _options, client_pid} = state) do
    Sample.Utils.log(id, "MQTT DISCONNECT")
    :ok = Sample.MqttAgent.MqttClient.disconnect(client_pid)
    state
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

