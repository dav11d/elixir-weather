defmodule Darksky do


  defmodule Geo.Location do
    @derive [Poison.Encoder]
    defstruct [:ip, :city, :latitude, :longitude]
  end

  defmodule Weather do
    @derive [Poison.Encoder]
    defstruct [:currently, :hourly, :daily]
  end

end

