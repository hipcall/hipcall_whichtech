defmodule HipcallWhichtech.Detector.Tawk do
  @moduledoc false

  @patterns [
    ~s(src="https://embed.tawk.to),
    ~s(var Tawk_API)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
