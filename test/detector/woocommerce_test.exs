defmodule HipcallWhichtech.Detector.WoocommerceTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Woocommerce

  describe "detect/1" do
    test "returns true when HTML contains WooCommerce plugin assets pattern" do
      html = ~s(<script src="/wp-content/plugins/woocommerce/assets/js/frontend.js"></script>)
      assert Woocommerce.detect(html) == true
    end

    test "returns true when HTML contains WooCommerce generator meta tag" do
      html = ~s(<meta name="generator" content="WooCommerce 6.5.1">)
      assert Woocommerce.detect(html) == true
    end

    test "returns true when HTML contains both patterns" do
      html = ~s(
        <meta name="generator" content="WooCommerce 7.0.0">
        <link rel="stylesheet" href="/wp-content/plugins/woocommerce/assets/css/woocommerce.css">
      )
      assert Woocommerce.detect(html) == true
    end

    test "returns false when HTML does not contain any WooCommerce patterns" do
      html = ~s(
        <html>
          <head>
            <title>Test Page</title>
            <meta name="generator" content="WordPress 6.0">
          </head>
          <body>
            <h1>Hello World</h1>
            <script src="/wp-content/themes/theme/script.js"></script>
          </body>
        </html>
      )
      assert Woocommerce.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(
        <script src="/wp-content/plugins/woo-commerce/assets/script.js"></script>
        <meta name="generator" content="Shopify">
      )
      assert Woocommerce.detect(html) == false
    end

    test "returns false for empty string" do
      assert Woocommerce.detect("") == false
    end

    test "returns false for whitespace-only string" do
      assert Woocommerce.detect("   \n\t  ") == false
    end

    test "is case sensitive - returns false for different case" do
      html = ~s(<meta name="generator" content="woocommerce 6.0">)
      assert Woocommerce.detect(html) == false
    end

    test "detects pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="generator" content="WooCommerce 6.8.2">
          <title>Online Store</title>
        </head>
        <body>
          <div class="container">
            <h1>Welcome to our store</h1>
          </div>
        </body>
        </html>
      )
      assert Woocommerce.detect(html) == true
    end

    test "detects pattern in minified HTML" do
      html = ~s(<html><head><meta name="generator" content="WooCommerce 7.1"></head><body><div>Content</div></body></html>)
      assert Woocommerce.detect(html) == true
    end
  end
end
