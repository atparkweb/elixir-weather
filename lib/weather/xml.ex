defmodule Weather.XML do
  require Logger
  import Record

  @lib_path "xmerl/include/xmerl.hrl"

  defrecord(:xmlElement, extract(:xmlElement, from_lib: @lib_path))
  defrecord(:xmlAttribute, extract(:xmlAttribute, from_lib: @lib_path))
  defrecord(:xmlText, extract(:xmlText, from_lib: @lib_path))
  
  def get_child_elements(element) do
    Enum.filter(xmlElement(element, :content), fn child ->
      Record.is_record(child, :xmlElement)
    end)
  end
  
  def find_child(children, name) do
    Enum.find(children, fn child -> xmlElement(child, :name) == name end)
  end
  
  def get_text(element) do
    Logger.info "Get text..."
    Enum.find(xmlElement(element, :content), fn child -> 
      Record.is_record(child, :xmlText)
    end)
    |> xmlText(:value)
  end
end
