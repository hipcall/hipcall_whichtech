defmodule HipcallWhichtech.Detector.IdeasoftTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Ideasoft

  describe "detect/1" do
    test "returns true when HTML contains IdeaSoft copyright meta tag" do
      html =
        ~s(<meta name='copyright' content='Copyright © 2007 Programlama IdeaSoft Akıllı E-Ticaret'/>)

      assert Ideasoft.detect(html) == true
    end

    test "returns true when HTML contains ideacdn.net image pattern" do
      html = ~s(<img src="//ideacdn.net/idea/product123.jpg" alt="Product">)
      assert Ideasoft.detect(html) == true
    end

    test "returns true when HTML contains ideacdn.net script pattern" do
      html = ~s(<script type="text/javascript" src="//ideacdn.net/js/app.js"></script>)
      assert Ideasoft.detect(html) == true
    end

    test "returns true when HTML contains IdeaSoft footer pattern" do
      html =
        ~s(<a href="https://www.ideasoft.com.tr" target="_blank" title="IdeaSoft" rel="noopener">IdeaSoft<sup>®</sup></a>
    <span>|</span>
    <a href="https://www.eticaret.com" target="_blank" title="E-ticaret" rel="noopener">Akıllı E-Ticaret paketleri</a> ile hazırlanmıştır.)

      assert Ideasoft.detect(html) == true
    end

    test "returns true when HTML contains multiple patterns" do
      html = ~s(
        <meta name='copyright' content='Copyright © 2007 Programlama IdeaSoft Akıllı E-Ticaret'/>
        <img src="//ideacdn.net/idea/logo.png" alt="Logo">
        <script type="text/javascript" src="//ideacdn.net/js/main.js"></script>
      )
      assert Ideasoft.detect(html) == true
    end

    test "returns false when HTML does not contain any IdeaSoft patterns" do
      html = ~s(
        <html>
          <head>
            <title>Test Page</title>
            <meta name="copyright" content="Other Company">
          </head>
          <body>
            <h1>Hello World</h1>
            <img src="//cdn.example.com/image.jpg">
          </body>
        </html>
      )
      assert Ideasoft.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(
        <meta name='copyright' content='Copyright © 2007 IdeaSoft'/>
        <img src="//ideacdn.com/idea/image.jpg">
        <script src="//ideacdn.net/script.js">
      )
      assert Ideasoft.detect(html) == false
    end

    test "returns false for empty string" do
      assert Ideasoft.detect("") == false
    end

    test "returns false for whitespace-only string" do
      assert Ideasoft.detect("   \n\t  ") == false
    end

    test "detects pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html lang="tr">
        <head>
          <meta charset="UTF-8">
          <meta name='copyright' content='Copyright © 2007 Programlama IdeaSoft Akıllı E-Ticaret'/>
          <title>E-ticaret Sitesi</title>
        </head>
        <body>
          <div class="container">
            <h1>Mağazamıza Hoş Geldiniz</h1>
          </div>
        </body>
        </html>
      )
      assert Ideasoft.detect(html) == true
    end

    test "detects pattern in minified HTML" do
      html =
        ~s(<html><head><meta name='copyright' content='Copyright © 2007 Programlama IdeaSoft Akıllı E-Ticaret'/></head><body><div>Content</div></body></html>)

      assert Ideasoft.detect(html) == true
    end
  end
end
