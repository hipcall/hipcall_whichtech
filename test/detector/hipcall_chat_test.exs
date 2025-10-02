defmodule HipcallWhichtech.Detector.HipcallChatTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.HipcallChat

  describe "detect/1" do
    test "returns true when HTML contains HipcallChat widget URL pattern" do
      html = ~s(<script src="https://use.hipcall.com.tr/widget/abc123.js"></script>)
      assert HipcallChat.detect(html) == true
    end

    test "returns true when HTML contains HipcallChat widget initialization pattern" do
      html = ~s(<script>var w = w || []; w['HipcallWidget'] = {widget_key: 'abc123'};</script>)
      assert HipcallChat.detect(html) == true
    end

    test "returns true when HTML contains both HipcallChat patterns" do
      html = ~s(
        <script src="https://use.hipcall.com.tr/widget/abc123.js"></script>
        <script>var w = w || []; w['HipcallWidget'] = {widget_key: 'abc123'};</script>
      )
      assert HipcallChat.detect(html) == true
    end

    test "returns false when HTML does not contain any HipcallChat patterns" do
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
      assert HipcallChat.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(
        <script src="https://use.hipcall.com.tr/otherpath/abc123.js"></script>
        <script>var w = w || []; w['OtherWidget'] = {widget_key: 'abc123'};</script>
      )
      assert HipcallChat.detect(html) == false
    end
  end
end
