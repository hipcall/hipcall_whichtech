defmodule HipcallWhichtech.Detector.KommoTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Kommo

  describe "detect/1" do
    test "returns true when HTML contains gso.kommo.com pattern" do
      html = ~s(<script src="https://gso.kommo.com/"></script>)
      assert Kommo.detect(html) == true
    end
    test "returns true when HTML contains drive-g.kommo.com pattern" do
      html = ~s(<script src="https://drive-g.kommo.com/"></script>)
      assert Kommo.detect(html) == true
    end
    test "returns true when HTML contains lc-en.kommo.com pattern" do
      html = ~s(<script src="wss://lc-en.kommo.com/"></script>)
      assert Kommo.detect(html) == true
    end
  end
end
