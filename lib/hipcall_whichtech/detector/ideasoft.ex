defmodule HipcallWhichtech.Detector.Ideasoft do
  @moduledoc false

  @patterns [
    ~s(<meta name='copyright' content='Copyright © 2007 Programlama IdeaSoft Akıllı E-Ticaret'/>),
    ~s(<img src="//ideacdn.net/idea/),
    ~s(<script type="text/javascript" src="//ideacdn.net/),
    ~s(<a href="https://www.ideasoft.com.tr" target="_blank" title="IdeaSoft" rel="noopener">IdeaSoft<sup>®</sup></a>
    <span>|</span>
    <a href="https://www.eticaret.com" target="_blank" title="E-ticaret" rel="noopener">Akıllı E-Ticaret paketleri</a> ile hazırlanmıştır.)
  ]

  @spec detect(html_source :: binary()) :: boolean()
  def detect(html_source) when is_binary(html_source) do
    Enum.any?(@patterns, fn pattern ->
      String.contains?(html_source, pattern)
    end)
  end
end
