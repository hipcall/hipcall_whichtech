defmodule HipcallWhichtech.Detector.WebflowTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Webflow

  describe "detect/1" do
    test "returns true when HTML contains website-files.com assets pattern" do
      html = ~s(<script src="https://assets-global.website-files.com/js/app.js"></script>)
      assert Webflow.detect(html) == true
    end

    test "returns true when HTML contains data-wf-domain attribute" do
      html = ~s(<div data-wf-domain="example.webflow.io">)
      assert Webflow.detect(html) == true
    end

    test "returns true when HTML contains data-wf-page attribute" do
      html = ~s(<body data-wf-page="60a1b2c3d4e5f6789">)
      assert Webflow.detect(html) == true
    end

    test "returns true when HTML contains data-wf-site attribute" do
      html = ~s(<html data-wf-site="60a1b2c3d4e5f6789">)
      assert Webflow.detect(html) == true
    end

    test "returns true when HTML contains multiple patterns" do
      html = ~s(
        <html data-wf-site="site123">
        <head>
          <link href="https://assets-global.website-files.com/css/style.css" rel="stylesheet">
        </head>
        <body data-wf-page="page456" data-wf-domain="mysite.webflow.io">
        </body>
        </html>
      )
      assert Webflow.detect(html) == true
    end

    test "returns false when HTML does not contain any Webflow patterns" do
      html = ~s(
        <html>
          <head>
            <title>Test Page</title>
            <script src="https://example.com/script.js"></script>
          </head>
          <body>
            <h1>Hello World</h1>
            <div data-site="example">Content</div>
          </body>
        </html>
      )
      assert Webflow.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(
        <script src="https://assets.website-files.com/script.js"></script>
        <div data-webflow-domain="example.com">
        <body data-wf-page-id="123">
      )
      assert Webflow.detect(html) == false
    end

    test "returns false for empty string" do
      assert Webflow.detect("") == false
    end

    test "returns false for whitespace-only string" do
      assert Webflow.detect("   \n\t  ") == false
    end

    test "detects pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html lang="en" data-wf-site="60a1b2c3d4e5f6789">
        <head>
          <meta charset="UTF-8">
          <title>My Webflow Site</title>
        </head>
        <body>
          <div class="container">
            <h1>Welcome</h1>
          </div>
        </body>
        </html>
      )
      assert Webflow.detect(html) == true
    end

    test "detects pattern in minified HTML" do
      html = ~s(<html data-wf-site="123"><head></head><body><div>Content</div></body></html>)
      assert Webflow.detect(html) == true
    end
  end
end
