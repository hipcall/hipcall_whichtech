defmodule HipcallWhichtech.Detector.Tsoft do
  @moduledoc false

  @patterns [
    ~s(/css/fonts/tsoft-icon.woff2?v=1" type="font/woff2" crossorigin>),
    ~s(TSOFT_APPS.page),
    ~s(<script src="/js/tsoftapps/),
    ~s(<a href="https://www.tsoft.com.tr" target="_blank" title="T-Soft E-ticaret Sistemleri">
    <span>T</span>-Soft
    </a> <a href="https://www.tsoft.com.tr" target="_blank" title="E-ticaret">E-Ticaret</a> Sistemleriyle Hazırlanmıştır.)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
