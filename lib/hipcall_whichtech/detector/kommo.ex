defmodule HipcallWhichtech.Detector.Kommo do
  @moduledoc false

  @patterns [
    ~s(https://gso.kommo.com/),
    ~s(https://drive-g.kommo.com/),
    ~s(wss://lc-en.kommo.com/)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
