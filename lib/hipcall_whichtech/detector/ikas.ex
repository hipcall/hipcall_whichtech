defmodule HipcallWhichtech.Detector.Ikas do
  @moduledoc false

  @patters [
    ~s(src="https://cdn.myikas.com)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patters, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
