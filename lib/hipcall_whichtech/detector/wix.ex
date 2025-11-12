defmodule HipcallWhichtech.Detector.Wix do
  @moduledoc """
  Detects Wix presence in HTML.
  """

  @doc """
  Detects Wix presence in HTML.
  """
  @patterns [
    ~s(id="wix-fedops"),
    ~s(id="wix-essential-viewer-model"),
    ~s(id="wixDesktopViewport"),
    ~s(content="Wix.com Website Builder"),
    ~s(https://static.wixstatic.com),
    ~s(type="wix/htmlEmbeds"),
    ~s(http-equiv="X-Wix-Published-Version"),
    ~s(http-equiv="X-Wix-Meta-Site-Id"),
    ~s(http-equiv="X-Wix-Application-Instance-Id"),
    ~s(id="wix-first-paint"),
    ~s(srcset="https://static.wixstatic.com/media/),
    ~s(src="https://static.wixstatic.com/media/),
    ~s(wix-dropdown-menu),
    ~s(wixui-text-input),
    ~s(title="Wix Chat"),
    ~s(aria-label="Wix Chat"),
    ~s(engage.wixapps.net)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
