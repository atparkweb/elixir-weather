defmodule Weather.CLI do
  @moduledoc """
  Main entry point and command line interface for application
  """
  require Logger

  alias Weather.XML,        as: XML
  alias Weather.API,        as: API
  alias Weather.Formatter,  as: Formatter
  alias Weather.FileWriter, as: FileWriter

  def main(argv) do
    argv 
    |> parse_args
    |> process
  end
  
  @doc """
  Return location code argument otherwise return :help
  """
  def parse_args(argv) do
    parsed = OptionParser.parse(argv, switches: [ help: :boolean ], aliases: [ h: :help ])
    
    case parsed do
      { [ help: true ], _, _ }
	-> :help
      { _, [ location ], _}
        -> location
      _ -> :help
    end
  end
  
  @doc """
  Display message about usage if --help or -h flag is present
  """
  def process(:help) do
    IO.puts """
    usage: weather <location_code>
    location_code should be NWA 4-letter location code
    """
  end
  @doc """
  Get the weather data for <location> from Weather service API.
  Parse the XML from response string
  """
  def process(location) do
    { :ok, body } = API.fetch(location)

    body
      |> (&FileWriter.xml_to_file(location, &1)).()
      |> XML.parse
      |> XML.get_child_elements
      |> Formatter.format
  end
end
