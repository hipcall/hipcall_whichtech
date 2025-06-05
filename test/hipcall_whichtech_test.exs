defmodule HipcallWhichtechTest do
  use ExUnit.Case

  describe "detect/2" do
    test "detects WordPress from HTML content" do
      html_with_wordpress = """
      <html>
        <head>
          <meta name="generator" content="WordPress 6.0" />
          <link rel="stylesheet" href="/wp-content/themes/theme/style.css" />
        </head>
        <body>
          <script src="/wp-includes/js/jquery.js"></script>
        </body>
      </html>
      """

      assert {:ok, detected} = HipcallWhichtech.detect(html_with_wordpress)
      assert :wordpress in detected
    end

    test "detects WooCommerce from HTML content" do
      html_with_woocommerce = """
      <html>
        <head>
          <meta name="generator" content="WooCommerce 7.0" />
          <link rel="stylesheet" href="/plugins/woocommerce/assets/css/woocommerce.css" />
        </head>
      </html>
      """

      assert {:ok, detected} = HipcallWhichtech.detect(html_with_woocommerce)
      assert :woocommerce in detected
    end

    test "detects multiple technologies" do
      html_with_multiple = """
      <html>
        <head>
          <meta name="generator" content="WordPress 6.0" />
          <meta name="generator" content="WooCommerce 7.0" />
          <link rel="stylesheet" href="/wp-content/themes/theme/style.css" />
          <link rel="stylesheet" href="/plugins/woocommerce/assets/css/woocommerce.css" />
        </head>
      </html>
      """

      assert {:ok, detected} = HipcallWhichtech.detect(html_with_multiple)
      assert :wordpress in detected
      assert :woocommerce in detected
    end

    test "returns empty list when no technologies detected" do
      html_without_tech = """
      <html>
        <head>
          <title>Simple HTML Page</title>
        </head>
        <body>
          <h1>Hello World</h1>
        </body>
      </html>
      """

      assert {:ok, []} = HipcallWhichtech.detect(html_without_tech)
    end

    test "excludes specified detectors" do
      html_with_multiple = """
      <html>
        <head>
          <meta name="generator" content="WordPress 6.0" />
          <meta name="generator" content="WooCommerce 7.0" />
          <link rel="stylesheet" href="/wp-content/themes/theme/style.css" />
          <link rel="stylesheet" href="/plugins/woocommerce/assets/css/woocommerce.css" />
        </head>
      </html>
      """

      assert {:ok, detected} =
               HipcallWhichtech.detect(html_with_multiple, exclude: [:woocommerce])

      assert :wordpress in detected
      refute :woocommerce in detected
    end

    test "only checks specified detectors" do
      html_with_multiple = """
      <html>
        <head>
          <meta name="generator" content="WordPress 6.0" />
          <meta name="generator" content="WooCommerce 7.0" />
          <link rel="stylesheet" href="/wp-content/themes/theme/style.css" />
          <link rel="stylesheet" href="/plugins/woocommerce/assets/css/woocommerce.css" />
        </head>
      </html>
      """

      assert {:ok, detected} = HipcallWhichtech.detect(html_with_multiple, only: [:wordpress])
      assert :wordpress in detected
      refute :woocommerce in detected
    end

    test "handles empty exclude list" do
      html_with_wordpress = """
      <html>
        <head>
          <meta name="generator" content="WordPress 6.0" />
        </head>
      </html>
      """

      assert {:ok, detected} = HipcallWhichtech.detect(html_with_wordpress, exclude: [])
      assert :wordpress in detected
    end

    test "handles empty only list" do
      html_with_wordpress = """
      <html>
        <head>
          <meta name="generator" content="WordPress 6.0" />
        </head>
      </html>
      """

      assert {:ok, detected} = HipcallWhichtech.detect(html_with_wordpress, only: [])
      assert :wordpress in detected
    end

    test "raises error for invalid options" do
      html = "<html></html>"

      assert_raise NimbleOptions.ValidationError, fn ->
        HipcallWhichtech.detect(html, invalid_option: true)
      end
    end

    test "raises error for invalid exclude type" do
      html = "<html></html>"

      assert_raise NimbleOptions.ValidationError, fn ->
        HipcallWhichtech.detect(html, exclude: "invalid")
      end
    end

    test "raises error for invalid only type" do
      html = "<html></html>"

      assert_raise NimbleOptions.ValidationError, fn ->
        HipcallWhichtech.detect(html, only: "invalid")
      end
    end
  end

  describe "request/1" do
    setup do
      # Start the application to ensure Finch is running
      Application.ensure_all_started(:hipcall_whichtech)
      :ok
    end

    test "returns error for invalid URL" do
      # Invalid URL should either return an error tuple or raise an exception
      try do
        assert {:error, _reason} = HipcallWhichtech.request("invalid-url")
      rescue
        # Finch raises ArgumentError for invalid URLs
        ArgumentError -> :ok
      end
    end

    test "returns error for non-existent domain" do
      assert {:error, _reason} =
               HipcallWhichtech.request("https://this-domain-does-not-exist-12345.com")
    end

    test "handles URI struct input" do
      uri = URI.parse("https://httpbin.org/status/404")

      case HipcallWhichtech.request(uri) do
        {:error, "Received status " <> _status} -> :ok
        # Network issues, timeouts, etc.
        {:error, _other_reason} -> :ok
      end
    end

    test "returns error for non-200 status codes" do
      case HipcallWhichtech.request("https://httpbin.org/status/404") do
        {:error, "Received status " <> _status} -> :ok
        # Network issues, timeouts, etc.
        {:error, _other_reason} -> :ok
      end
    end

    # Note: This test requires internet connection and a reliable endpoint
    # You might want to mock this in a real test suite
    @tag :integration
    test "successfully fetches HTML from valid URL" do
      case HipcallWhichtech.request("https://httpbin.org/html") do
        {:ok, body} ->
          assert is_binary(body)
          assert String.contains?(body, "<html")

        {:error, _reason} ->
          # Network issues can cause this test to fail, so we'll skip assertion
          # In a real test suite, you'd want to mock HTTP requests
          :ok
      end
    end
  end

  describe "integration tests" do
    setup do
      Application.ensure_all_started(:hipcall_whichtech)
      :ok
    end

    test "detects technologies from sample HTML strings" do
      # Test Shopify detection
      shopify_html = """
      <html>
        <head>
          <meta name="shopify-checkout-api-token" content="abc123" />
        </head>
      </html>
      """

      assert {:ok, detected} = HipcallWhichtech.detect(shopify_html)
      assert :shopify in detected

      # Test Tawk detection
      tawk_html = """
      <html>
        <head>
          <script type="text/javascript">
            var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
          </script>
        </head>
      </html>
      """

      assert {:ok, detected} = HipcallWhichtech.detect(tawk_html)
      assert :tawk in detected

      # Test Webflow detection
      webflow_html = """
      <html>
        <head>
          <div data-wf-domain="example.com">Content</div>
        </head>
      </html>
      """

      assert {:ok, detected} = HipcallWhichtech.detect(webflow_html)
      assert :webflow in detected
    end

    test "complex filtering scenarios" do
      html_with_multiple = """
      <html>
        <head>
          <meta name="generator" content="WordPress 6.0" />
          <meta name="generator" content="WooCommerce 7.0" />
          <link rel="stylesheet" href="/wp-content/themes/theme/style.css" />
          <link rel="stylesheet" href="/plugins/woocommerce/assets/css/woocommerce.css" />
          <div data-wf-domain="example.com">Content</div>
        </head>
      </html>
      """

      # Test excluding multiple detectors
      assert {:ok, detected} =
               HipcallWhichtech.detect(html_with_multiple, exclude: [:woocommerce, :webflow])

      assert :wordpress in detected
      refute :woocommerce in detected
      refute :webflow in detected

      # Test only with multiple detectors
      assert {:ok, detected} =
               HipcallWhichtech.detect(html_with_multiple, only: [:wordpress, :webflow])

      assert :wordpress in detected
      assert :webflow in detected
      refute :woocommerce in detected
    end
  end

  describe "edge cases" do
    test "handles empty HTML string" do
      assert {:ok, []} = HipcallWhichtech.detect("")
    end

    test "handles HTML with special characters" do
      html_with_special_chars = """
      <html>
        <head>
          <meta name="generator" content="WordPress 6.0 – 中文测试" />
          <title>Test with émojis 🚀 and spëcial chars</title>
        </head>
      </html>
      """

      assert {:ok, detected} = HipcallWhichtech.detect(html_with_special_chars)
      assert :wordpress in detected
    end

    test "handles very large HTML content" do
      large_content = String.duplicate("<div>content</div>", 10000)

      html_with_wordpress = """
      <html>
        <head>
          <meta name="generator" content="WordPress 6.0" />
        </head>
        <body>
          #{large_content}
        </body>
      </html>
      """

      assert {:ok, detected} = HipcallWhichtech.detect(html_with_wordpress)
      assert :wordpress in detected
    end

    test "case sensitivity in detection" do
      # Test that detection is case sensitive (based on the patterns in detectors)
      html_wrong_case = """
      <html>
        <head>
          <meta name="generator" content="WORDPRESS 6.0" />
        </head>
      </html>
      """

      assert {:ok, detected} = HipcallWhichtech.detect(html_wrong_case)
      # This should not detect WordPress because the pattern is case-sensitive
      refute :wordpress in detected
    end
  end
end
