defmodule HipcallWhichtech.Detector.Crisp do
  @moduledoc false

  @patterns [
    ~s(https://client.crisp.chat/),
    ~s(https://client.relay.crisp.chat),
    ~s(id="crisp-chatbox"),
    ~s(id="crisp-chatbox-button"),
    ~s(id="crisp-chatbox-chat"),
    ~s(class="crisp-client"),
    ~s(crisp-chatbox-chat),
    ~s(components/crisp),
    ~s(../../components/crisp)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
