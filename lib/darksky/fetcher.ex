defmodule Darksky.Fetcher do

  alias Darksky.Fetcher, as: Fetcher
  @base_url "https://api.darksky.net/forecast/"
  @forecast_io_api_key Application.get_env :darksky, :forecast_io_api_key

  def fetch(latitude, longitude, opts \\ %{}) when is_map(opts) do
    case HTTPoison.get("#{@base_url}#{@forecast_io_api_key}/#{latitude},#{longitude}", [], params: opts) do
      {:ok, %{body: body}} -> Poison.decode!(body, as: %Darksky.Weather{})
      _ -> {:error, "Couldn't retrieve the weather."}
    end

  end

  def run do
    location = Fetcher.geoip
    lat = location.latitude
    long = location.longitude
    city = location.city
    response = Fetcher.fetch(lat, long, %{lang: "en", units: "auto"})
    {:ok, unixt} = DateTime.from_unix(response.currently["time"])
    time = DateTime.to_string(unixt)
    IO.puts("The weather in #{city} is #{response.currently["summary"]} with a temperature of #{response.currently["temperature"]} at #{time}")
  end


  def geoip do
    case HTTPoison.get("http://freegeoip.net/json/") do
      {:ok, %{body: body}} -> Poison.decode!(body, as: %Darksky.Geo.Location{})
    end
  end

end