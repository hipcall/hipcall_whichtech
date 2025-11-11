defmodule HipcallWhichtech.Detector.Platinmarket do
  @moduledoc false

  @patterns [
    ~s(<link rel="icon" href="https://platincdn.com),
    ~s(<p><a href="//www.platinmarket.com" target="_blank" rel="noopener" title="e-ticaret eticaret">PlatinMarket<sup>®</sup> E-Ticaret Sistemi</a> İle Hazırlanmıştır.</p>),
    ~s(<img loading="lazy" src="https://platincdn.com/)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
