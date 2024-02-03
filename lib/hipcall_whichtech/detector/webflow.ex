defmodule HipcallWhichtech.Detector.Webflow do
  @moduledoc false

  @patters [
    ~s(https://assets-global.website-files.com),
    ~s(data-wf-domain="),
    ~s(data-wf-page="),
    ~s(data-wf-site=")
  ]

  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patters, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
