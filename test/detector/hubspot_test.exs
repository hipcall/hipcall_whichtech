defmodule HipcallWhichtech.Detector.HubspotTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Hubspot

  describe "detect/1" do
    test "returns true when HTML contains HubSpot generator meta tag" do
      html = ~s(<meta name="generator" content="HubSpot">)
      assert Hubspot.detect(html) == true
    end

    test "returns true when HTML contains HubSpot generator with version" do
      html = ~s(<meta name="generator" content="HubSpot 2.0">)
      assert Hubspot.detect(html) == true
    end

    test "returns true when HTML contains HubSpot generator in larger meta tag" do
      html = ~s(<meta name="generator" content="HubSpot CMS Platform">)
      assert Hubspot.detect(html) == true
    end

    test "returns false when HTML does not contain any HubSpot patterns" do
      html = ~s(
        <html>
          <head>
            <title>Test Page</title>
            <meta name="generator" content="WordPress">
          </head>
          <body>
            <h1>Hello World</h1>
          </body>
        </html>
      )
      assert Hubspot.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(
        <meta name="generator" content="Hub Spot">
        <meta name="platform" content="HubSpot">
      )
      assert Hubspot.detect(html) == false
    end

    test "returns false for empty string" do
      assert Hubspot.detect("") == false
    end

    test "returns false for whitespace-only string" do
      assert Hubspot.detect("   \n\t  ") == false
    end

    test "is case sensitive - returns false for different case" do
      html = ~s(<meta name="generator" content="hubspot">)
      assert Hubspot.detect(html) == false
    end

    test "detects pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <meta name="generator" content="HubSpot">
          <title>Marketing Site</title>
        </head>
        <body>
          <div class="container">
            <h1>Welcome to our site</h1>
          </div>
        </body>
        </html>
      )
      assert Hubspot.detect(html) == true
    end

    test "detects pattern in minified HTML" do
      html =
        ~s(<html><head><meta name="generator" content="HubSpot"></head><body><div>Content</div></body></html>)

      assert Hubspot.detect(html) == true
    end
  end
end
