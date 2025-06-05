defmodule HipcallWhichtech.Detector.EticaretkurTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Eticaretkur

  describe "detect/1" do
    test "returns true when HTML contains Eticaret Kur link pattern" do
      html =
        ~s(<a href="https://www.eticaretkur.com" target="_blank" class="rSiyah_0">Eticaret Kur</a> <a href="https://www.eticaretkur.com" target="_blank" title="E-Ticaret Paketi, E-Ticaret Sitesi, E-Ticaret Yazılımı"><b>E-Ticaret</b></a> Sistemi İle Hazırlanmıştır)

      assert Eticaretkur.detect(html) == true
    end

    test "returns true when HTML contains ekur-menu CSS pattern" do
      html = ~s(<link href="/Themes/Default/Styles/ekur-menu.css?v=1.2.3" rel="stylesheet">)
      assert Eticaretkur.detect(html) == true
    end

    test "returns true when HTML contains ekur-menu div pattern" do
      html = ~s(<div id="ekur-menu" class="Categories">)
      assert Eticaretkur.detect(html) == true
    end

    test "returns true when HTML contains multiple patterns" do
      html = ~s(
        <link href="/Themes/Default/Styles/ekur-menu.css?v=2.0" rel="stylesheet">
        <div id="ekur-menu" class="Categories">
          <a href="https://www.eticaretkur.com" target="_blank" class="rSiyah_0">Eticaret Kur</a>
        </div>
      )
      assert Eticaretkur.detect(html) == true
    end

    test "returns false when HTML does not contain any Eticaretkur patterns" do
      html = ~s(
        <html>
          <head><title>Test Page</title></head>
          <body>
            <h1>Hello World</h1>
            <script src="https://example.com/script.js"></script>
          </body>
        </html>
      )
      assert Eticaretkur.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(
        <a href="https://www.eticaret.com" target="_blank">Different Site</a>
        <div id="menu" class="Categories">
      )
      assert Eticaretkur.detect(html) == false
    end

    test "returns false for empty string" do
      assert Eticaretkur.detect("") == false
    end

    test "returns false for whitespace-only string" do
      assert Eticaretkur.detect("   \n\t  ") == false
    end

    test "detects pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html lang="tr">
        <head>
          <meta charset="UTF-8">
          <title>E-ticaret Sitesi</title>
          <link href="/Themes/Default/Styles/ekur-menu.css?v=3.1" rel="stylesheet">
        </head>
        <body>
          <div class="container">
            <h1>Mağazamıza Hoş Geldiniz</h1>
          </div>
        </body>
        </html>
      )
      assert Eticaretkur.detect(html) == true
    end

    test "detects pattern in minified HTML" do
      html =
        ~s(<html><head><link href="/Themes/Default/Styles/ekur-menu.css?v=1"></head><body><div>Content</div></body></html>)

      assert Eticaretkur.detect(html) == true
    end
  end
end
