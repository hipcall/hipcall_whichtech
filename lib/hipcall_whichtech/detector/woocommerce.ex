defmodule HipcallWhichtech.Detector.Woocommerce do
  @moduledoc false

  @patters [
    ~s(/plugins/woocommerce/assets/),
    ~s(<meta name="generator" content="WooCommerce)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) do
    Enum.any?(@patters, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
