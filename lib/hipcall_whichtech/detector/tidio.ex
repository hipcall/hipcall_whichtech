defmodule HipcallWhichtech.Detector.Tidio do
  @moduledoc false

  @patterns [
    ~s(src="//code.tidio.co/"),
    ~s(src: url(https://code.tidio.co/))
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
