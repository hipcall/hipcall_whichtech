defmodule HipcallWhichtech.Detector.KommoTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Kommo

  describe "detect/1" do
    test "returns true when HTML contains Kommo patterns" do
      html = ~s(<script src="https://gso.kommo.com/"></script>)
      assert Kommo.detect(html) == true
    end
    test "returns true when HTML contains Kommo patterns" do
      html = ~s(<script src="https://www.kommo.com/"></script>)
      assert Kommo.detect(html) == true
    end
    test "returns true when HTML contains Kommo patterns" do
      html = ~s(<script src="https://drive-g.kommo.com/"></script>)
      assert Kommo.detect(html) == true
    end
    test "returns true when HTML contains Kommo patterns" do
      html = ~s(<script src="wss://lc-en.kommo.com/"></script>)
      assert Kommo.detect(html) == true
    end
    test "returns true when HTML contains Kommo patterns" do
      html = ~s(Kommo CRM Plugin social network list)
      assert Kommo.detect(html) == true
    end
    test "returns true when HTML contains Kommo patterns" do
      html = ~s(Kommo Live Chat)
      assert Kommo.detect(html) == true
    end
    test "returns true when HTML contains Kommo patterns" do
      html = ~s(Made by Kommo)
      assert Kommo.detect(html) == true
    end
  end
end
