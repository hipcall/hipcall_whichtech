defmodule HipcallWhichtech.Detector.TawkTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Tawk

  describe "detect/1" do
    test "returns true when HTML contains Tawk.to embed script" do
      html = ~s(<script src="https://embed.tawk.to/chat.js"></script>)
      assert Tawk.detect(html) == true
    end

    test "returns true when HTML contains Tawk_API variable" do
      html = ~s(<script>var Tawk_API = {};</script>)
      assert Tawk.detect(html) == true
    end

    test "returns true when HTML contains both patterns" do
      html = ~s[
        <script src="https://embed.tawk.to/widget.js"></script>
        <script>var Tawk_API = {onLoad: function(){}};</script>
      ]
      assert Tawk.detect(html) == true
    end

    test "returns false when HTML does not contain any Tawk patterns" do
      html = ~s(
        <html>
          <head>
            <title>Test Page</title>
            <script src="https://example.com/chat.js"></script>
          </head>
          <body>
            <h1>Hello World</h1>
            <script>var ChatAPI = {};</script>
          </body>
        </html>
      )
      assert Tawk.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(
        <script src="https://embed.tawk.com/script.js"></script>
        <script>var Tawk_Widget = {};</script>
      )
      assert Tawk.detect(html) == false
    end

    test "returns false for empty string" do
      assert Tawk.detect("") == false
    end

    test "returns false for whitespace-only string" do
      assert Tawk.detect("   \n\t  ") == false
    end

    test "is case sensitive - returns false for different case" do
      html = ~s(<script>var tawk_api = {};</script>)
      assert Tawk.detect(html) == false
    end

    test "detects pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <title>Customer Support</title>
        </head>
        <body>
          <div class="container">
            <h1>Contact Us</h1>
          </div>
          <script src="https://embed.tawk.to/5f123456789/default"></script>
        </body>
        </html>
      )
      assert Tawk.detect(html) == true
    end

    test "detects pattern in minified HTML" do
      html = ~s(<html><head></head><body><script>var Tawk_API={};</script></body></html>)
      assert Tawk.detect(html) == true
    end

    test "detects Tawk_API in complex script" do
      html = ~s[
        <script>
          var Tawk_API = Tawk_API || {};
          Tawk_API.onLoad = function(){
            console.log('Tawk loaded');
          };
        </script>
      ]
      assert Tawk.detect(html) == true
    end
  end
end
