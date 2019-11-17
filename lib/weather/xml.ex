defmodule Weather.XML do
  @moduledoc """
  Converts Erlang xml map to Elixir records for faster access.
  Wraps XPath API in Elixir functions
  """
  require Logger
  import Record

  @lib_path "xmerl/include/xmerl.hrl"

  defrecord(:xmlElement, extract(:xmlElement, from_lib: @lib_path))
  defrecord(:xmlAttribute, extract(:xmlAttribute, from_lib: @lib_path))
  defrecord(:xmlText, extract(:xmlText, from_lib: @lib_path))
  
  @doc """
  Returns a list of children of <element>
  """
  def get_child_elements(element) do
    Enum.filter(xmlElement(element, :content), fn child ->
      Record.is_record(child, :xmlElement)
    end)
  end
  
  @doc """
  Find a child xmlElement within <children> that matches <name>
  """
  def find_child(children, name) do
    Enum.find(children, fn child -> xmlElement(child, :name) == name end)
  end
  
  @doc """
  Get the text content of <element>
  """
  def get_text(element) do
    Logger.info "Get text..."
    Enum.find(xmlElement(element, :content), fn child -> 
      Record.is_record(child, :xmlText)
    end)
    |> xmlText(:value)
  end

  @doc """
  Use underlying Erlang XML parsing library (xmerl)
  to parse XML content
  """
  def parse(str) do
    Logger.info "Parsing XML with xmerl..."
    { doc, [] } = str |> :binary.bin_to_list() |> :xmerl_scan.string()
    doc
  end
end
