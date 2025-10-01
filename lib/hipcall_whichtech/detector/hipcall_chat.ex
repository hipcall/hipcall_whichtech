defmodule HipcallWhichtech.Detector.HipcallChat do
  @moduledoc false

  @patterns [
    ~s(ea5e6c8a-0810-49e3-892c-5bcb6aadf231)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
