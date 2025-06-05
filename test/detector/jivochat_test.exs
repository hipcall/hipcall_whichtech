defmodule HipcallWhichtech.Detector.JivochatTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Jivochat

  describe "detect/1" do
    test "returns true when HTML contains Jivo CSS link pattern" do
      html = ~s(<link rel="stylesheet" href="https://code.jivosite.com/widget/styles.css">)
      assert Jivochat.detect(html) == true
    end

    test "returns true when HTML contains Jivo script pattern" do
      html = ~s(<script src="//code.jivosite.com/widget/jivo.js"></script>)
      assert Jivochat.detect(html) == true
    end

    test "returns true when HTML contains jivo-iframe-container pattern" do
      html = ~s(<div class="jivo-iframe-container">Chat widget</div>)
      assert Jivochat.detect(html) == true
    end

    test "returns true when HTML contains jdiv class pattern" do
      html = ~s(<jdiv class="jivo-widget">)
      assert Jivochat.detect(html) == true
    end

    test "returns true when HTML contains jdiv id pattern" do
      html = ~s(<jdiv id="jivo-chat-widget">)
      assert Jivochat.detect(html) == true
    end

    test "returns true when HTML contains multiple patterns" do
      html = ~s(
        <link rel="stylesheet" href="https://code.jivosite.com/widget/main.css">
        <script src="//code.jivosite.com/widget/chat.js"></script>
        <div class="jivo-iframe-container">
          <jdiv class="chat-widget">
        </div>
      )
      assert Jivochat.detect(html) == true
    end

    test "returns false when HTML does not contain any Jivochat patterns" do
      html = ~s(
        <html>
          <head>
            <title>Test Page</title>
            <script src="https://example.com/chat.js"></script>
          </head>
          <body>
            <h1>Hello World</h1>
            <div class="chat-container">Chat</div>
          </body>
        </html>
      )
      assert Jivochat.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(
        <link rel="stylesheet" href="https://code.jivo.com/widget/styles.css">
        <script src="//jivosite.com/widget/script.js">
        <div class="jivo-container">
      )
      assert Jivochat.detect(html) == false
    end

    test "returns false for empty string" do
      assert Jivochat.detect("") == false
    end

    test "returns false for whitespace-only string" do
      assert Jivochat.detect("   \n\t  ") == false
    end

    test "detects pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <title>Customer Support</title>
          <link rel="stylesheet" href="https://code.jivosite.com/widget/chat.css">
        </head>
        <body>
          <div class="container">
            <h1>Contact Us</h1>
          </div>
        </body>
        </html>
      )
      assert Jivochat.detect(html) == true
    end

    test "detects pattern in minified HTML" do
      html = ~s(<html><head><script src="//code.jivosite.com/widget/min.js"></script></head><body><div>Content</div></body></html>)
      assert Jivochat.detect(html) == true
    end
  end
end
