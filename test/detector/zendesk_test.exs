defmodule HipcallWhichtech.Detector.ZendeskTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Zendesk

  describe "detect/1" do
    test "returns true when HTML contains assets.zendesk.com pattern" do
      html = ~s(https://assets.zendesk.com/)
      assert Zendesk.detect(html) == true
    end

    test "returns true when HTML contains 'Built with Zendesk' pattern" do
      html = ~s(<div>Built with Zendesk</div>)
      assert Zendesk.detect(html) == true
    end

    test "returns true when HTML contains 'this.zendeskHost' pattern" do
      html = ~s(<script>var host = this.zendeskHost;</script>)
      assert Zendesk.detect(html) == true
    end

    test "returns true when HTML contains multiple Zendesk patterns" do
      html =
        ~s(<script src="https://assets.zendesk.com/script.js"></script><div>Built with Zendesk</div>)

      assert Zendesk.detect(html) == true
    end

    test "returns false when HTML does not contain any Zendesk patterns" do
      html = ~s(https://example.com/script.js)
      assert Zendesk.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(https://assets.abc123.com/)
      assert Zendesk.detect(html) == false
    end

    test "returns false when HTML contains zendeskHost without 'this.' prefix" do
      html = ~s(<script>var host = zendeskHost;</script>)
      assert Zendesk.detect(html) == false
    end
  end
end
