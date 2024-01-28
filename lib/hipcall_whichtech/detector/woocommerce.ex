defmodule HipcallWhichtech.Detector.Woocommerce do
  @patters [
    ~s(/plugins/woocommerce/assets/),
    ~s(<meta name="generator" content="WooCommerce)
  ]

  def detect(html_source) do
    Enum.any?(@patters, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
