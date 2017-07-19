defmodule Whoppex.Utils do

  @doc """
    Check if a module is an implementation of behavior.

        iex> implements?(App.Application, Application)
        true

        iex> implements?(IO, Application)
        false
  """
  def implements?(module, behavior) do
    module.module_info[:attributes]
    |> Keyword.get(:behaviour, [])
    |> Enum.member?(behavior)
  end

  @doc """
    Check if an application is started and running

        iex> app_started?(:kernel)
        true

        iex> app_started?(:other_app)
        false
  """
  def app_started?(application) do
    Application.started_applications() |> Keyword.has_key?(application)
  end

end
