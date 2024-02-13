# HipcallWhichtech

Find out what the website is built with using this package.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `hipcall_whichtech` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hipcall_whichtech, "~> 0.3.0"}
  ]
end
```

## Use

Documentation for using, please check the `HipcallWhichtech` module.

### Example

```elixir
iex> {:ok, html_body} = HipcallWhichtech.request("https://woo.com/")
iex> HipcallWhichtech.detect(html_body)
...> {:ok, [:wordpress, :woocommerce]}

iex> {:ok, html_body} = HipcallWhichtech.request("https://www.bulutfon.com/")
iex> HipcallWhichtech.detect(html_body)
...> {:ok, [:wordpress]}
```

## Detectors

- [x] Hubspot
- [x] Shopify
- [x] Webflow
- [x] Woocommerce
- [x] Wordpress
- [x] Ikas

## Hipcall

All [Hipcall](https://www.hipcall.com/en-gb/) libraries:

- [HipcallDisposableEmail](https://github.com/hipcall/hipcall_disposable_email) - Simple library checking the email's domain is disposable or not.
- [HipcallDeepgram](https://github.com/hipcall/hipcall_deepgram) - Unofficial Deepgram API Wrapper written in Elixir.
- [HipcallOpenai](https://github.com/hipcall/hipcall_openai) - Unofficial OpenAI API Wrapper written in Elixir.
- [HipcallWhichtech](https://github.com/hipcall/hipcall_whichtech) - Find out what the website is built with.

