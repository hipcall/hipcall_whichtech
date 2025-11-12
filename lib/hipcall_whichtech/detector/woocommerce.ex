defmodule HipcallWhichtech.Detector.Woocommerce do
  @moduledoc false

  @patterns [
    ~s(/plugins/woocommerce/assets/),
    ~s(<meta name="generator" content="WooCommerce)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
