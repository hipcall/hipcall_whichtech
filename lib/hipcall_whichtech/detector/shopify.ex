defmodule HipcallWhichtech.Detector.Shopify do
  @moduledoc false

  @patterns [
    ~s(<meta name="shopify-checkout-api-token" content="),
    ~s(<meta id="shopify-digital-wallet" name="shopify-digital-wallet"),
    ~s(<script id="shopify-features" type="application/json">)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
