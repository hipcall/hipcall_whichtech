defmodule HipcallWhichtech.Detector.HipcallChatTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.HipcallChat

  describe "detect/1" do
    test "returns true when HTML contains Hipcall UUID pattern" do
      html =
        ~s(<script id="hc" src="./Hipcall is all in one communication solutions - Hipcall_files/ea5e6c8a-0810-49e3-892c-5bcb6aadf231" async=""></script>)

      assert HipcallChat.detect(html) == true
    end

    test "returns true when HTML contains Hipcall UUID in different script context" do
      html =
        ~s(<script src="https://use.hipcall.com/widget/ea5e6c8a-0810-49e3-892c-5bcb6aadf231"></script>)

      assert HipcallChat.detect(html) == true
    end

    test "returns true when HTML contains Hipcall UUID without full script tag" do
      html =
        ~s(some random text ea5e6c8a-0810-49e3-892c-5bcb6aadf231 more text)

      assert HipcallChat.detect(html) == true
    end

    test "returns true when HTML contains multiple Hipcall patterns" do
      html = ~s[
        <script id="hc" src="./files/ea5e6c8a-0810-49e3-892c-5bcb6aadf231" async=""></script>
        <div id="hipcall-widget">
          <div id="hc-launcher"></div>
        </div>
      ]
      assert HipcallChat.detect(html) == true
    end

    test "returns false when HTML does not contain any Hipcall patterns" do
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

    test "returns false when HTML contains similar but not exact UUID pattern" do
      html = ~s[
        <script src="https://use.hipcall.com/widget/different-uuid-123456"></script>
        <script src="https://anotherdomain.com/some-other-uuid-abcdef"></script>
      ]
      assert HipcallChat.detect(html) == false
    end

    test "returns false when HTML contains partial UUID" do
      html = ~s[
        <script src="https://use.hipcall.com/widget/ea5e6c8a-0810-49e3"></script>
      ]
      assert HipcallChat.detect(html) == false
    end
  end
end
