defmodule HipcallWhichtech.Detector.Hubspot do
  @moduledoc false

  @patters [
    ~s(generator" content="HubSpot)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patters, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
