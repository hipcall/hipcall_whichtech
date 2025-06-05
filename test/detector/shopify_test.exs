defmodule HipcallWhichtech.Detector.ShopifyTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Shopify

  describe "detect/1" do
    test "returns true when HTML contains shopify-checkout-api-token meta tag" do
      html = ~s(<meta name="shopify-checkout-api-token" content="abc123">)
      assert Shopify.detect(html) == true
    end

    test "returns true when HTML contains shopify-digital-wallet meta tag" do
      html = ~s(<meta id="shopify-digital-wallet" name="shopify-digital-wallet" content="1">)
      assert Shopify.detect(html) == true
    end

    test "returns true when HTML contains shopify-features script" do
      html = ~s(<script id="shopify-features" type="application/json">{"features":[]}</script>)
      assert Shopify.detect(html) == true
    end

    test "returns true when HTML contains multiple patterns" do
      html = ~s(
        <meta name="shopify-checkout-api-token" content="token123">
        <meta id="shopify-digital-wallet" name="shopify-digital-wallet" content="enabled">
        <script id="shopify-features" type="application/json">{"analytics":true}</script>
      )
      assert Shopify.detect(html) == true
    end

    test "returns false when HTML does not contain any Shopify patterns" do
      html = ~s(
        <html>
          <head>
            <title>Test Page</title>
            <meta name="checkout-token" content="abc123">
          </head>
          <body>
            <h1>Hello World</h1>
            <script type="application/json">{"features":[]}</script>
          </body>
        </html>
      )
      assert Shopify.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(
        <meta name="shopify-token" content="abc123">
        <meta id="digital-wallet" name="digital-wallet">
        <script id="features" type="application/json">
      )
      assert Shopify.detect(html) == false
    end

    test "returns false for empty string" do
      assert Shopify.detect("") == false
    end

    test "returns false for whitespace-only string" do
      assert Shopify.detect("   \n\t  ") == false
    end

    test "is case sensitive - returns false for different case" do
      html = ~s(<meta name="SHOPIFY-CHECKOUT-API-TOKEN" content="abc123">)
      assert Shopify.detect(html) == false
    end

    test "detects pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <meta name="shopify-checkout-api-token" content="shop_token_123">
          <title>Online Store</title>
        </head>
        <body>
          <div class="container">
            <h1>Welcome to our store</h1>
          </div>
        </body>
        </html>
      )
      assert Shopify.detect(html) == true
    end

    test "detects pattern in minified HTML" do
      html =
        ~s(<html><head><meta name="shopify-checkout-api-token" content="token"></head><body><div>Content</div></body></html>)

      assert Shopify.detect(html) == true
    end
  end
end
