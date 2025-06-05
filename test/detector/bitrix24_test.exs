defmodule HipcallWhichtech.Detector.Bitrix24Test do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Bitrix24

  describe "detect/1" do
    test "returns true when HTML contains Bitrix24 disclaimer text" do
      html = ~s(Bitrix24 is not responsible for information supplied in this form. However, you can always report a violation.)
      assert Bitrix24.detect(html) == true
    end

    test "returns true when HTML contains bitrix/js/imopenlines script path" do
      html = ~s(<script src="/bitrix/js/imopenlines/connector.js"></script>)
      assert Bitrix24.detect(html) == true
    end

    test "returns true when HTML contains bitrix/js/imopenlines in script tag" do
      html = ~s(<script type="text/javascript" src="https://example.com/bitrix/js/imopenlines/widget.js"></script>)
      assert Bitrix24.detect(html) == true
    end

    test "returns true when HTML contains disclaimer text within larger content" do
      html = ~s(
        <div class="footer">
          <p>Contact us for more information.</p>
          <p>Bitrix24 is not responsible for information supplied in this form. However, you can always report a violation.</p>
          <p>Terms and conditions apply.</p>
        </div>
      )
      assert Bitrix24.detect(html) == true
    end

    test "returns false when HTML does not contain any Bitrix24 patterns" do
      html = ~s(
        <html>
          <head>
            <title>Test Page</title>
            <meta name="generator" content="WordPress">
          </head>
          <body>
            <h1>Hello World</h1>
            <script src="/js/app.js"></script>
          </body>
        </html>
      )
      assert Bitrix24.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(
        <div>Bitrix is not responsible for this content</div>
        <script src="/bitrix/js/other/script.js"></script>
      )
      assert Bitrix24.detect(html) == false
    end

    test "returns false for empty string" do
      assert Bitrix24.detect("") == false
    end

    test "returns false for whitespace-only string" do
      assert Bitrix24.detect("   \n\t  ") == false
    end

    test "is case sensitive - returns false for different case in disclaimer" do
      html = ~s(bitrix24 is not responsible for information supplied in this form. however, you can always report a violation.)
      assert Bitrix24.detect(html) == false
    end

    test "is case sensitive - returns false for different case in script path" do
      html = ~s(<script src="/BITRIX/JS/IMOPENLINES/connector.js"></script>)
      assert Bitrix24.detect(html) == false
    end

    test "detects disclaimer pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <title>Contact Form</title>
        </head>
        <body>
          <form>
            <input type="text" name="name">
            <input type="email" name="email">
            <button type="submit">Submit</button>
          </form>
          <footer>
            <small>Bitrix24 is not responsible for information supplied in this form. However, you can always report a violation.</small>
          </footer>
        </body>
        </html>
      )
      assert Bitrix24.detect(html) == true
    end

    test "detects script pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html>
        <head>
          <title>Chat Widget</title>
        </head>
        <body>
          <div id="content">
            <h1>Welcome</h1>
          </div>
          <script src="/bitrix/js/imopenlines/widget.min.js"></script>
          <script>
            // Initialize chat widget
          </script>
        </body>
        </html>
      )
      assert Bitrix24.detect(html) == true
    end

    test "detects pattern in minified HTML" do
      html = ~s(<html><head></head><body><div>Content</div><script src="/bitrix/js/imopenlines/chat.js"></script></body></html>)
      assert Bitrix24.detect(html) == true
    end

    test "detects disclaimer in minified HTML" do
      html = ~s(<html><body><form><input type="text"><small>Bitrix24 is not responsible for information supplied in this form. However, you can always report a violation.</small></form></body></html>)
      assert Bitrix24.detect(html) == true
    end

    test "returns true when both patterns are present" do
      html = ~s(
        <html>
        <head>
          <script src="/bitrix/js/imopenlines/connector.js"></script>
        </head>
        <body>
          <form>
            <input type="text">
            <p>Bitrix24 is not responsible for information supplied in this form. However, you can always report a violation.</p>
          </form>
        </body>
        </html>
      )
      assert Bitrix24.detect(html) == true
    end

    test "handles HTML with special characters and encoding" do
      html = ~s(
        <div>
          <p>Formulaire de contact</p>
          <small>Bitrix24 is not responsible for information supplied in this form. However, you can always report a violation.</small>
        </div>
      )
      assert Bitrix24.detect(html) == true
    end
  end
end
