defmodule Weather.IO do
  require Logger

  @output_directory "output"
  
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
  
  defp save_xml(name, contents, dest) do
    IO.puts "Name: #{name}"
    :ok = File.write("#{dest}/#{name}.xml", contents)
  end
end
