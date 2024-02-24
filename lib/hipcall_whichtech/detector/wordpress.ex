defmodule HipcallWhichtech.Detector.Wordpress do
  @moduledoc false

  @patters [
    "/wp-content/",
    "/wp-includes/",
    "wp-json",
    ~s(generator" content="WordPress)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) do
    Enum.any?(@patters, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
