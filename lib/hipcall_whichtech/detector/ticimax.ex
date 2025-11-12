defmodule HipcallWhichtech.Detector.Ticimax do
  @moduledoc false

  @patterns [
    ~s(<link rel="preload" as="image" href="https://static.ticimax.cloud/),
    ~s(<link rel="icon" href="https://static.ticimax.cloud/),
    ~s(<a rel="sponsored" class="mobilTicimaxLogo" href="https://www.ticimax.com" title="Ticimax E-Ticaret Sistemleri" target="_blank">)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
