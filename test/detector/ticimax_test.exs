defmodule HipcallWhichtech.Detector.TicimaxTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Ticimax

  describe "detect/1" do
    test "returns true when HTML contains ticimax.cloud preload link pattern" do
      html = ~s(<link rel="preload" as="image" href="https://static.ticimax.cloud/images/logo.png">)
      assert Ticimax.detect(html) == true
    end

    test "returns true when HTML contains ticimax.cloud icon link pattern" do
      html = ~s(<link rel="icon" href="https://static.ticimax.cloud/favicon.ico">)
      assert Ticimax.detect(html) == true
    end

    test "returns true when HTML contains Ticimax footer link pattern" do
      html = ~s(<a rel="sponsored" class="mobilTicimaxLogo" href="https://www.ticimax.com" title="Ticimax E-Ticaret Sistemleri" target="_blank">)
      assert Ticimax.detect(html) == true
    end

    test "returns true when HTML contains multiple patterns" do
      html = ~s(
        <link rel="preload" as="image" href="https://static.ticimax.cloud/assets/banner.jpg">
        <link rel="icon" href="https://static.ticimax.cloud/favicon.ico">
        <a rel="sponsored" class="mobilTicimaxLogo" href="https://www.ticimax.com" title="Ticimax E-Ticaret Sistemleri" target="_blank">
      )
      assert Ticimax.detect(html) == true
    end

    test "returns false when HTML does not contain any Ticimax patterns" do
      html = ~s(
        <html>
          <head>
            <title>Test Page</title>
            <link rel="icon" href="https://example.com/favicon.ico">
          </head>
          <body>
            <h1>Hello World</h1>
            <a href="https://example.com">Link</a>
          </body>
        </html>
      )
      assert Ticimax.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(
        <link rel="preload" href="https://static.ticimax.net/image.jpg">
        <link rel="icon" href="https://ticimax.cloud/favicon.ico">
        <a href="https://www.ticimax.net">Different Site</a>
      )
      assert Ticimax.detect(html) == false
    end

    test "returns false for empty string" do
      assert Ticimax.detect("") == false
    end

    test "returns false for whitespace-only string" do
      assert Ticimax.detect("   \n\t  ") == false
    end

    test "detects pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html lang="tr">
        <head>
          <meta charset="UTF-8">
          <title>E-ticaret Sitesi</title>
          <link rel="preload" as="image" href="https://static.ticimax.cloud/assets/hero.jpg">
        </head>
        <body>
          <div class="container">
            <h1>Mağazamıza Hoş Geldiniz</h1>
          </div>
        </body>
        </html>
      )
      assert Ticimax.detect(html) == true
    end

    test "detects pattern in minified HTML" do
      html = ~s(<html><head><link rel="icon" href="https://static.ticimax.cloud/icon.ico"></head><body><div>Content</div></body></html>)
      assert Ticimax.detect(html) == true
    end
  end
end
