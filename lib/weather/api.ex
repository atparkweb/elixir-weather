defmodule Weather.API do
  require Logger

  @weather_url "https://w1.weather.gov/xml/current_obs"
  
  def fetch(location_code) do
    data_url(location_code)
    |> HTTPoison.get
    |> handle_response
  end
  
  def data_url(location_code) do
    "#{@weather_url}/#{location_code}.xml"
  end
  
  def handle_response({:ok, %HTTPoison.Response{ status_code: status, body: body }}) do
    Logger.info "Successful response #{status}"
    { :ok, body }
  end
  def handle_response({_, %HTTPoison.Response{ status_code: status, body: body}}) do
    Logger.error "Error #{status} returned"
    { :error, body }
  end
  
end
