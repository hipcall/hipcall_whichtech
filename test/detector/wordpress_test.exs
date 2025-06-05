defmodule HipcallWhichtech.Detector.WordpressTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Wordpress

  describe "detect/1" do
    test "returns true when HTML contains wp-content path" do
      html = ~s(<script src="/wp-content/themes/theme/script.js"></script>)
      assert Wordpress.detect(html) == true
    end

    test "returns true when HTML contains wp-includes path" do
      html = ~s(<script src="/wp-includes/js/jquery.js"></script>)
      assert Wordpress.detect(html) == true
    end

    test "returns true when HTML contains wp-json reference" do
      html = ~s(<link rel="https://api.w.org/" href="https://example.com/wp-json/">)
      assert Wordpress.detect(html) == true
    end

    test "returns true when HTML contains WordPress generator meta tag" do
      html = ~s(<meta name="generator" content="WordPress 6.2">)
      assert Wordpress.detect(html) == true
    end

    test "returns true when HTML contains multiple patterns" do
      html = ~s(
        <meta name="generator" content="WordPress 6.3">
        <script src="/wp-content/themes/twentytwentythree/script.js"></script>
        <link rel="stylesheet" href="/wp-includes/css/dist/block-library/style.min.css">
      )
      assert Wordpress.detect(html) == true
    end

    test "returns false when HTML does not contain any WordPress patterns" do
      html = ~s(
        <html>
          <head>
            <title>Test Page</title>
            <meta name="generator" content="Hugo">
          </head>
          <body>
            <h1>Hello World</h1>
            <script src="/assets/js/app.js"></script>
          </body>
        </html>
      )
      assert Wordpress.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(
        <script src="/content/themes/theme/script.js"></script>
        <meta name="generator" content="Word Press">
        <link href="/includes/style.css">
      )
      assert Wordpress.detect(html) == false
    end

    test "returns false for empty string" do
      assert Wordpress.detect("") == false
    end

    test "returns false for whitespace-only string" do
      assert Wordpress.detect("   \n\t  ") == false
    end

    test "is case sensitive - returns false for different case" do
      html = ~s(<meta name="generator" content="wordpress 6.0">)
      assert Wordpress.detect(html) == false
    end

    test "detects pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="generator" content="WordPress 6.4">
          <title>My Blog</title>
        </head>
        <body>
          <div class="container">
            <h1>Welcome to my blog</h1>
          </div>
        </body>
        </html>
      )
      assert Wordpress.detect(html) == true
    end

    test "detects pattern in minified HTML" do
      html =
        ~s(<html><head><script src="/wp-content/themes/theme/app.js"></script></head><body><div>Content</div></body></html>)

      assert Wordpress.detect(html) == true
    end

    test "detects wp-json in REST API link" do
      html =
        ~s(<link rel="alternate" type="application/json" href="https://example.com/wp-json/wp/v2/posts">)

      assert Wordpress.detect(html) == true
    end
  end
end
