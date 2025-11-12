defmodule HipcallWhichtech.Detector.Bitrix24 do
  @moduledoc false

  @patterns [
    ~s('https://cdn.bitrix24.com),
    ~s(data-b24-crm-button-block),
    ~s(Bitrix24 is not responsible for information supplied in this form. However, you can always report a violation.),
    ~s(bitrix/js/imopenlines)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
