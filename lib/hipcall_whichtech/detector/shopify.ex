defmodule HipcallWhichtech.Detector.Shopify do
  @patters [
    ~s(<meta name="shopify-checkout-api-token" content="),
    ~s(<meta id="shopify-digital-wallet" name="shopify-digital-wallet"),
    ~s(<script id="shopify-features" type="application/json">)
  ]

  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patters, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
