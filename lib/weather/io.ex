defmodule Weather.IO do
  @moduledoc """
  Read/write functions for XML data
  """
  require Logger

  @output_directory "output"
  
  @doc """
  Makes an output directory if it doesn't already exist and save contents to XML.
  Returns <contents> to be piped to other functions
  """
  def xml_to_file(name, contents) do
    { :ok, current } = File.cwd()
    dest = "#{current}/#{@output_directory}"
    unless File.exists?(dest) do
      Logger.info "Creating output directory at: #{dest}"
      :ok = File.mkdir!(dest)
    end
    :ok = save_xml(name, contents, dest)
    contents
  end
  
  @doc """
  Write contents to an XML file at <dest>/<name>.xml
  """
  defp save_xml(name, contents, dest) do
    IO.puts "Name: #{name}"
    :ok = File.write("#{dest}/#{name}.xml", contents)
  end
end
