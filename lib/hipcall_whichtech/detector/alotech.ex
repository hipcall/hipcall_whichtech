defmodule HipcallWhichtech.Detector.AloTech do
  @moduledoc false

  @patterns [
    ~s(src="https://chatserver.alo-tech.com/static/assets/js/linkify.min.js"),
    ~s(src="https://chatserver.alo-tech.com/static/assets/js/linkify.html.min.js"),
    ~s(.alo-tech.com/click2connects/click2connect.js?widget_key=)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
