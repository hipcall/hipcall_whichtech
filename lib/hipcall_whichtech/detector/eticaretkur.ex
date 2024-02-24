defmodule HipcallWhichtech.Detector.Eticaretkur do
  @moduledoc false

  @patters [
    ~s(<a href="https://www.eticaretkur.com" target="_blank" class="rSiyah_0">Eticaret Kur</a> <a href="https://www.eticaretkur.com" target="_blank" title="E-Ticaret Paketi, E-Ticaret Sitesi, E-Ticaret Yazılımı"><b>E-Ticaret</b></a> Sistemi İle Hazırlanmıştır),
    ~s(<link href="/Themes/Default/Styles/ekur-menu.css?v=),
    ~s(<div id="ekur-menu" class="Categories">)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patters, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
