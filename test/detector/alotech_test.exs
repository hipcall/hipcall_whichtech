defmodule HipcallWhichtech.Detector.AloTechTest do
  use ExUnit.Case

  alias HipcallWhichtech.Detector.AloTech

  describe "detect/1" do
    test "returns true when HTML contains AloTech linkify.min.js pattern" do
      html =
        ~s(<script src="https://chatserver.alo-tech.com/static/assets/js/linkify.min.js"></script>)

      assert AloTech.detect(html) == true
    end

    test "returns true when HTML contains AloTech linkify.html.min.js pattern" do
      html =
        ~s(<script src="https://chatserver.alo-tech.com/static/assets/js/linkify.html.min.js"></script>)

      assert AloTech.detect(html) == true
    end

    test "returns true when HTML contains AloTech click2connect.js pattern" do
      html =
        ~s(<script src="https://chatserver.alo-tech.com/click2connects/click2connect.js?widget_key=abc123"></script>)

      assert AloTech.detect(html) == true
    end

    test "returns true when HTML contains multiple AloTech patterns" do
      html = ~s[
        <script src="https://chatserver.alo-tech.com/static/assets/js/linkify.min.js"></script>
        <script src="https://chatserver.alo-tech.com/click2connects/click2connect.js?widget_key=abc123"></script>
      ]
      assert AloTech.detect(html) == true
    end

    test "returns false when HTML does not contain any AloTech patterns" do
      html = ~s(
        <html>
          <head>
            <title>Test Page</title>
            <script src="/js/app.js"></script>
          </head>
          <body>
            <h1>Hello World</h1>
            <a href="https://example.com">Link</a>
          </body>
        </html>
      )
      assert AloTech.detect(html) == false
    end

    test "returns false when HTML contains similar but not exact patterns" do
      html = ~s[
        <script src="https://chatserver.alo-tech.com/static/assets/js/otherfile.js"></script>
        <script src="https://anotherdomain.com/click2connects/click2connect.js?widget_key=abc123"></script>
      ]
      assert AloTech.detect(html) == false
    end
  end
end
