defmodule Weather.CLI do
  require Logger

  alias Weather.XML, as: XML

  def main(argv) do
    argv 
    |> parse_args
    |> process
  end
  
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
  
  def process(:help) do
    IO.puts """
    usage: weather <location_code>
    location_code should be NWA 4-letter location code
    """
  end
  def process(location) do
    { :ok, body } = Weather.API.fetch(location)

    body
    |> (&Weather.IO.xml_to_file("test", &1)).()
    |> parse_xml
    |> XML.get_child_elements
    |> XML.find_child(:location)
    |> XML.get_text
    |> IO.inspect
  end

  @doc """
  Use underlying Erlang XML parsing library (xmerl)
  to parse XML content
  """
  def parse_xml(str) do
    Logger.info "Parsing XML with xmerl..."
    { doc, [] } = str |> :binary.bin_to_list() |> :xmerl_scan.string()
    doc
  end
end
