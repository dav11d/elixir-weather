defmodule Darksky do


  @base_url "https://api.darksky.net/forecast/"

  
  @forecast_io_api_key Application.get_env :darksky, :forecast_io_api_key

  defmodule Weather do
    @derive [Poison.Encoder]
    defstruct [:hourly, :summary, :daily]
  end


  def fetch(latitude, longitude, opts \\ %{}) when is_map(opts) do
    case HTTPoison.get("#{@base_url}#{@forecast_io_api_key}/#{latitude},#{longitude}", [], params: opts) do
      {:ok, %{body: body}} -> Poison.decode!(body, as: %{"Weather" => [%Weather{}]})
      _ -> {:error, "Couldn't retrieve the weather."}
    end

  end

  def run do
    response = fetch(55.826 ,-4.257, %{lang: "en", units: "si"})
    {:ok, unixt} = DateTime.from_unix(response["currently"]["time"])
    time = DateTime.to_string(unixt)
    IO.puts("The current weather right now is #{response["currently"]["summary"]}\n
    with a temperature of #{response["currently"]["temperature"]} at #{time}")
  end


end