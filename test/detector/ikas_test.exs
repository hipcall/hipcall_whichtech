defmodule HipcallWhichtech.Detector.IkasTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Ikas

  describe "detect/1" do
    test "returns true when HTML contains cdn.myikas.com pattern" do
      html = ~s(<script src="https://cdn.myikas.com/assets/js/app.js"></script>)
      assert Ikas.detect(html) == true
    end

    test "returns true when HTML contains eu.myikas.com pattern" do
      html = ~s(<img src="https://eu.myikas.com/images/logo.png" alt="Logo">)
      assert Ikas.detect(html) == true
    end

    test "returns true when HTML contains both patterns" do
      html = ~s(
        <script src="https://cdn.myikas.com/assets/js/app.js"></script>
        <img src="https://eu.myikas.com/images/logo.png" alt="Logo">
      )
      assert Ikas.detect(html) == true
    end

    test "returns true when pattern appears multiple times" do
      html = ~s(
        <script src="https://cdn.myikas.com/assets/js/app.js"></script>
        <link rel="stylesheet" href="https://cdn.myikas.com/assets/css/style.css">
      )
      assert Ikas.detect(html) == true
    end

    test "returns false when HTML does not contain any Ikas patterns" do
      html = ~s(
        <html>
          <head><title>Test Page</title></head>
          <body>
            <h1>Hello World</h1>
            <script src="https://example.com/script.js"></script>
          </body>
        </html>
      )
      assert Ikas.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(
        <script src="https://cdn.myikas.net/script.js"></script>
        <img src="us.myikas.com/image.png">
      )
      assert Ikas.detect(html) == false
    end

    test "returns false for empty string" do
      assert Ikas.detect("") == false
    end

    test "returns false for whitespace-only string" do
      assert Ikas.detect("   \n\t  ") == false
    end

    test "is case sensitive - returns false for different case" do
      html = ~s(<script src="https://CDN.MYIKAS.COM/script.js"></script>)
      assert Ikas.detect(html) == false
    end

    test "detects pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>E-commerce Site</title>
          <script src="https://cdn.myikas.com/assets/bundle.js"></script>
        </head>
        <body>
          <div class="container">
            <h1>Welcome to our store</h1>
            <p>Browse our products</p>
          </div>
        </body>
        </html>
      )
      assert Ikas.detect(html) == true
    end

    test "detects pattern in minified HTML" do
      html =
        ~s(<html><head><script src="https://cdn.myikas.com/min.js"></script></head><body><div>Content</div></body></html>)

      assert Ikas.detect(html) == true
    end
  end
end
