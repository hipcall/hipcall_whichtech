defmodule HipcallWhichtech.Detector.Hubspot do
  @patters [
    ~s(generator" content="HubSpot)
  ]

  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patters, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
