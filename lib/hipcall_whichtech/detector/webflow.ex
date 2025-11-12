defmodule HipcallWhichtech.Detector.Webflow do
  @moduledoc false

  @patterns [
    ~s(https://assets-global.website-files.com),
    ~s(data-wf-domain="),
    ~s(data-wf-page="),
    ~s(data-wf-site=")
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
