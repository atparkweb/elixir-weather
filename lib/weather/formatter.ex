defmodule Weather.Formatter do
  @moduledoc """
  Display weather data in readable format
  """
  
  @doc """
  Print weather xml doc to screen
  """
  def format(doc_root) do
    fields = [
      { :observation_time, "Time" },
      { :location, "Location" },
      { :weather, "Conditions" },
      { :temperature_string, "Temperature" },
      { :relative_humidity, "Humidity" }
    ]

    Enum.map(fields, fn { node, label } ->
      value = doc_root
        |> Weather.XML.find_child(node)
        |> Weather.XML.get_text
      "#{label}: #{value}\n"
    end) |> IO.puts
  end
end
