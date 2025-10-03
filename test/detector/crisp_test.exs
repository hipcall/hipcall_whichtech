defmodule HipcallWhichtech.Detector.CrispTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Crisp

  describe "detect/1" do
    test "returns true when HTML contains client.crisp.chat pattern" do
      html = ~s(https://client.crisp.chat/)
      assert Crisp.detect(html) == true
    end

    test "returns true when HTML contains client.relay.crisp.chat pattern" do
      html = ~s(https://client.relay.crisp.chat)
      assert Crisp.detect(html) == true
    end

    test "returns true when HTML contains crisp-chatbox id pattern" do
      html = ~s(<div id="crisp-chatbox"></div>)
      assert Crisp.detect(html) == true
    end

    test "returns false when HTML does not contain any Crisp patterns" do
      html = ~s(https://example.com/script.js)
      assert Crisp.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(https://client.crisp.example.com/)
      assert Crisp.detect(html) == false
    end
  end
end
