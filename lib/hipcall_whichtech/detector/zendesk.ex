defmodule HipcallWhichtech.Detector.Zendesk do
  @moduledoc false

  @patterns [
    ~s(https://assets.zendesk.com/),
    ~s(this.zendeskHost),
    ~s(Built with Zendesk)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
