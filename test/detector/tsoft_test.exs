defmodule HipcallWhichtech.Detector.TsoftTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Tsoft

  describe "detect/1" do
    test "returns true when HTML contains tsoft-icon font pattern" do
      html =
        ~s(<link rel="preload" href="/css/fonts/tsoft-icon.woff2?v=1" type="font/woff2" crossorigin>)

      assert Tsoft.detect(html) == true
    end

    test "returns true when HTML contains TSOFT_APPS.page pattern" do
      html = ~s[<script>TSOFT_APPS.page.init();</script>]
      assert Tsoft.detect(html) == true
    end

    test "returns true when HTML contains tsoftapps script pattern" do
      html = ~s(<script src="/js/tsoftapps/main.js"></script>)
      assert Tsoft.detect(html) == true
    end

    test "returns true when HTML contains T-Soft footer pattern" do
      html =
        ~s(<a href="https://www.tsoft.com.tr" target="_blank" title="T-Soft E-ticaret Sistemleri">
    <span>T</span>-Soft
    </a> <a href="https://www.tsoft.com.tr" target="_blank" title="E-ticaret">E-Ticaret</a> Sistemleriyle Hazırlanmıştır.)

      assert Tsoft.detect(html) == true
    end

    test "returns true when HTML contains multiple patterns" do
      html = ~s[
        <link rel="preload" href="/css/fonts/tsoft-icon.woff2?v=2" type="font/woff2" crossorigin>
        <script>TSOFT_APPS.page.load();</script>
        <script src="/js/tsoftapps/app.js"></script>
      ]
      assert Tsoft.detect(html) == true
    end

    test "returns false when HTML does not contain any T-Soft patterns" do
      html = ~s(
        <html>
          <head>
            <title>Test Page</title>
            <script src="/js/app.js"></script>
          </head>
          <body>
            <h1>Hello World</h1>
            <a href="https://example.com">Link</a>
          </body>
        </html>
      )
      assert Tsoft.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s[
        <link rel="preload" href="/css/fonts/tsoft.woff2" type="font/woff2">
        <script>TSOFT.page.init();</script>
        <script src="/js/tsoft/app.js"></script>
      ]
      assert Tsoft.detect(html) == false
    end

    test "returns false for empty string" do
      assert Tsoft.detect("") == false
    end

    test "returns false for whitespace-only string" do
      assert Tsoft.detect("   \n\t  ") == false
    end

    test "detects pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html lang="tr">
        <head>
          <meta charset="UTF-8">
          <title>E-ticaret Sitesi</title>
          <link rel="preload" href="/css/fonts/tsoft-icon.woff2?v=1" type="font/woff2" crossorigin>
        </head>
        <body>
          <div class="container">
            <h1>Mağazamıza Hoş Geldiniz</h1>
          </div>
        </body>
        </html>
      )
      assert Tsoft.detect(html) == true
    end

    test "detects pattern in minified HTML" do
      html =
        ~s[<html><head><script>TSOFT_APPS.page.start();</script></head><body><div>Content</div></body></html>]

      assert Tsoft.detect(html) == true
    end
  end
end
