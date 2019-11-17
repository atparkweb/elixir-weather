defmodule WeatherAPITest do
  use ExUnit.Case
  
  import Weather.API, only: [ data_url: 1, handle_response: 1 ]
  
  test "Generates correct request URL from code" do
    assert data_url("ABCD") == "https://w1.weather.gov/xml/current_obs/ABCD.xml"
  end
  
  test "Returns { :ok, body } on successful response" do
    assert handle_response({:ok, %HTTPoison.Response{
			       status_code: 200,
			       body: "success"
			    }}) == { :ok, "success"}
  end
  
  test "Returns { :error, body } on failed respones" do
    assert handle_response({:error, %HTTPoison.Response{
			       status_code: 500,
			       body: "error"
			    }}) == { :error, "error"}
  end
end
