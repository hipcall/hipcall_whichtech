defmodule HipcallWhichtech.Detector.TidioTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Tidio

  describe "detect/1" do
    test "returns true when HTML contains Tidio pattern" do
      html = ~s(aria-label="Powered by Tidio.")
      assert Tidio.detect(html) == true
    end
  end
end
