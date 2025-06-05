defmodule HipcallWhichtech.Detector.PlatinmarketTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Platinmarket

  describe "detect/1" do
    test "returns true when HTML contains platincdn.com icon link pattern" do
      html = ~s(<link rel="icon" href="https://platincdn.com/favicon.ico">)
      assert Platinmarket.detect(html) == true
    end

    test "returns true when HTML contains PlatinMarket footer pattern" do
      html = ~s(<p><a href="//www.platinmarket.com" target="_blank" rel="noopener" title="e-ticaret eticaret">PlatinMarket<sup>®</sup> E-Ticaret Sistemi</a> İle Hazırlanmıştır.</p>)
      assert Platinmarket.detect(html) == true
    end

    test "returns true when HTML contains platincdn.com image pattern" do
      html = ~s(<img loading="lazy" src="https://platincdn.com/images/product.jpg" alt="Product">)
      assert Platinmarket.detect(html) == true
    end

    test "returns true when HTML contains multiple patterns" do
      html = ~s(
        <link rel="icon" href="https://platincdn.com/favicon.ico">
        <img loading="lazy" src="https://platincdn.com/images/logo.png" alt="Logo">
        <p><a href="//www.platinmarket.com" target="_blank" rel="noopener" title="e-ticaret eticaret">PlatinMarket<sup>®</sup> E-Ticaret Sistemi</a> İle Hazırlanmıştır.</p>
      )
      assert Platinmarket.detect(html) == true
    end

    test "returns false when HTML does not contain any PlatinMarket patterns" do
      html = ~s(
        <html>
          <head>
            <title>Test Page</title>
            <link rel="icon" href="https://example.com/favicon.ico">
          </head>
          <body>
            <h1>Hello World</h1>
            <img src="https://cdn.example.com/image.jpg">
          </body>
        </html>
      )
      assert Platinmarket.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(
        <link rel="icon" href="https://platincdn.net/favicon.ico">
        <img src="https://platinmarket.com/image.jpg">
        <p><a href="//www.platinmarket.net">Different Platform</a></p>
      )
      assert Platinmarket.detect(html) == false
    end

    test "returns false for empty string" do
      assert Platinmarket.detect("") == false
    end

    test "returns false for whitespace-only string" do
      assert Platinmarket.detect("   \n\t  ") == false
    end

    test "detects pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html lang="tr">
        <head>
          <meta charset="UTF-8">
          <title>E-ticaret Sitesi</title>
          <link rel="icon" href="https://platincdn.com/assets/favicon.ico">
        </head>
        <body>
          <div class="container">
            <h1>Mağazamıza Hoş Geldiniz</h1>
          </div>
        </body>
        </html>
      )
      assert Platinmarket.detect(html) == true
    end

    test "detects pattern in minified HTML" do
      html = ~s(<html><head><link rel="icon" href="https://platincdn.com/icon.ico"></head><body><div>Content</div></body></html>)
      assert Platinmarket.detect(html) == true
    end
  end
end
