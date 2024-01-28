defmodule HipcallWhichtech.Detector.Wordpress do
  @patters [
    "/wp-content/",
    "/wp-includes/",
    "wp-json",
    ~s(generator" content="WordPress)
  ]

  def detect({:ok, html_source}) do
    detect(html_source)
  end

  def detect(html_source) do
    Enum.any?(@patters, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
