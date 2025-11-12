defmodule HipcallWhichtech.Detector.WixTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.Wix

  describe "detect/1" do
    # Core Wix CMS patterns
    test "returns true when HTML contains wix-fedops id" do
      html = ~s(<div id="wix-fedops"></div>)
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains wix-essential-viewer-model id" do
      html = ~s(<div id="wix-essential-viewer-model"></div>)
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains wixDesktopViewport id" do
      html = ~s(<div id="wixDesktopViewport"></div>)
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains Wix.com Website Builder meta content" do
      html = ~s(<meta name="generator" content="Wix.com Website Builder">)
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains static.wixstatic.com URL" do
      html = ~s(<script src="https://static.wixstatic.com/js/app.js"></script>)
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains wix/htmlEmbeds type" do
      html = ~s(<script type="wix/htmlEmbeds"></script>)
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains X-Wix-Published-Version meta" do
      html = ~s(<meta http-equiv="X-Wix-Published-Version" content="1.0">)
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains X-Wix-Meta-Site-Id meta" do
      html = ~s(<meta http-equiv="X-Wix-Meta-Site-Id" content="abc123">)
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains X-Wix-Application-Instance-Id meta" do
      html = ~s(<meta http-equiv="X-Wix-Application-Instance-Id" content="def456">)
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains wix-first-paint id" do
      html = ~s(<div id="wix-first-paint"></div>)
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains wixstatic.com media srcset" do
      html = ~s(<img srcset="https://static.wixstatic.com/media/image.jpg">)
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains wixstatic.com media src" do
      html = ~s(<img src="https://static.wixstatic.com/media/image.jpg">)
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains wix-dropdown-menu class" do
      html = ~s(<div class="wix-dropdown-menu"></div>)
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains wixui-text-input class" do
      html = ~s(<input class="wixui-text-input">)
      assert Wix.detect(html) == true
    end

    # Wix Chat patterns
    test "returns true when HTML contains Wix Chat title" do
      html = ~s(<iframe title="Wix Chat"></iframe>)
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains Wix Chat aria-label" do
      html = ~s(<iframe aria-label="Wix Chat"></iframe>)
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains engage.wixapps.net URL" do
      html = ~s(<script src="https://engage.wixapps.net/chat.js"></script>)
      assert Wix.detect(html) == true
    end

    # Multiple patterns
    test "returns true when HTML contains multiple Wix patterns" do
      html = ~s(
        <meta name="generator" content="Wix.com Website Builder">
        <div id="wix-fedops"></div>
        <script src="https://static.wixstatic.com/js/app.js"></script>
      )
      assert Wix.detect(html) == true
    end

    test "returns true when HTML contains both CMS and Chat patterns" do
      html = ~s(
        <div id="wix-essential-viewer-model"></div>
        <iframe title="Wix Chat"></iframe>
        <script src="https://engage.wixapps.net/chat.js"></script>
      )
      assert Wix.detect(html) == true
    end

    # Negative tests
    test "returns false when HTML does not contain any Wix patterns" do
      html = ~s(
        <html>
          <head>
            <title>Test Page</title>
            <meta name="generator" content="WordPress">
          </head>
          <body>
            <h1>Hello World</h1>
            <script src="/assets/js/app.js"></script>
          </body>
        </html>
      )
      assert Wix.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s(
        <div id="wix-fed-ops"></div>
        <meta name="generator" content="Wix Website Builder">
        <script src="https://static.example.com/media/image.jpg"></script>
        <div class="wix-dropdown"></div>
      )
      assert Wix.detect(html) == false
    end

    test "returns false for empty string" do
      assert Wix.detect("") == false
    end

    test "returns false for whitespace-only string" do
      assert Wix.detect("   \n\t  ") == false
    end

    test "is case sensitive - returns false for different case" do
      html = ~s(<meta name="generator" content="wix.com website builder">)
      assert Wix.detect(html) == false
    end

    # Real-world scenarios
    test "detects pattern within larger HTML document" do
      html = ~s(
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="generator" content="Wix.com Website Builder">
          <title>My Wix Site</title>
        </head>
        <body>
          <div class="container">
            <h1>Welcome to my site</h1>
            <div id="wix-fedops"></div>
          </div>
        </body>
        </html>
      )
      assert Wix.detect(html) == true
    end

    test "detects pattern in minified HTML" do
      html =
        ~s(<html><head><script src="https://static.wixstatic.com/js/app.js"></script></head><body><div>Content</div></body></html>)

      assert Wix.detect(html) == true
    end

    test "detects Wix Chat iframe in real-world scenario" do
      html = ~s(
        <div id="pinnedBottomRight" class="pinnedBottomRight">
          <div class="comp-kcfzlcf0-pinned-layer">
            <iframe class="nKphmK" title="Wix Chat" aria-label="Wix Chat" scrolling="no" allowfullscreen="" allowtransparency="true" allowvr="true" frameBorder="0" allow="clipboard-write;autoplay;camera;microphone;geolocation;vr"></iframe>
          </div>
        </div>
      )
      assert Wix.detect(html) == true
    end

    test "detects Wix static assets in various contexts" do
      html = ~s(
        <img src="https://static.wixstatic.com/media/dec40b_7639a9c71bf54a1283ad75e2089dd139~mv2.png" alt="Logo">
        <link rel="stylesheet" href="https://static.wixstatic.com/css/app.css">
        <script src="https://static.wixstatic.com/js/widget.js"></script>
      )
      assert Wix.detect(html) == true
    end

    test "detects Wix meta tags in head section" do
      html = ~s(
        <head>
          <meta http-equiv="X-Wix-Published-Version" content="1.0">
          <meta http-equiv="X-Wix-Meta-Site-Id" content="abc123def456">
          <meta http-equiv="X-Wix-Application-Instance-Id" content="789xyz">
        </head>
      )
      assert Wix.detect(html) == true
    end

    test "detects Wix UI components" do
      html = ~s(
        <form>
          <input class="wixui-text-input" type="text" placeholder="Name">
          <div class="wix-dropdown-menu">
            <select>
              <option>Option 1</option>
            </select>
          </div>
        </form>
      )
      assert Wix.detect(html) == true
    end

    test "detects Wix chat integration" do
      html = ~s(
        <script>
          // Wix chat integration
          window.wixChat = {
            api: "https://engage.wixapps.net/chat-widget-server/",
            config: {}
          };
        </script>
      )
      assert Wix.detect(html) == true
    end
  end
end
