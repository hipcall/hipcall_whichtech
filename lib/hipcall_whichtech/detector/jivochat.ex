defmodule HipcallWhichtech.Detector.Jivochat do
  @moduledoc false

  @patters [
    ~s(<link rel="stylesheet" href="https://code.jivosite.com/),
    ~s(<script src="//code.jivosite.com/widget/),
    ~s(jivo-iframe-container),
    ~s(<jdiv class="),
    ~s(<jdiv id="),
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patters, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
