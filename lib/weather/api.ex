defmodule Weather.API do
  @moduledoc """
  Handles requests to and responses from National Weather Service API
  """
  require Logger

  @weather_url "https://w1.weather.gov/xml/current_obs"
  
  @doc """
  Get XML weather data from weather.gov for location represented by <location_code>
  """
  def fetch(location_code) do
    data_url(location_code)
    |> HTTPoison.get
    |> handle_response
  end
  
  @doc """
  Build request URL for <location_code>
  
  ## Examples
      iex> Weather.API.data_url("KDTO")
      "https://w1.weather.gov/xml/current_obs/KDTO.xml"

  """
  def data_url(location_code) do
    "#{@weather_url}/#{location_code}.xml"
  end
  
  @doc """
  Handler for a success response from API.
  Returns `{ :ok, <body> }`
  `body` is an XML doc as string
  """
  def handle_response({:ok, %HTTPoison.Response{ status_code: status, body: body }}) do
    Logger.info "Successful response #{status}"
    { :ok, body }
  end
  @doc """
  Handler for an error response from API. Logs error to stdout.
  Returns `{ :error, <body> }`
  """
  def handle_response({_, %HTTPoison.Response{ status_code: status, body: body}}) do
    Logger.error "Error #{status} returned"
    { :error, body }
  end
  
end
