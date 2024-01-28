# HipcallWhichtech

Find out what the website is built with using this package.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `hipcall_whichtech` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hipcall_whichtech, "~> 0.1.0"}
  ]
end
```

## Use

Documentation for using, please check the `HipcallWhichtech` module.

### Example

    iex> HipcallWhichtech.detect("https://woo.com/")
    ...> {:ok, [:wordpress, :woocommerce]}
    iex> HipcallWhichtech.detect("https://www.bulutfon.com/")
    ...> {:ok, [:wordpress]}

## Detectors

- [x] Hubspot
- [x] Shopify
- [x] Woocommerce
- [x] Wordpress

## Hipcall

All [Hipcall](https://www.hipcall.com/en-gb/) libraries:

- [HipcallDisposableEmail](https://github.com/hipcall/hipcall_disposable_email) - Simple library checking the email's domain is disposable or not.
- [HipcallDeepgram](https://github.com/hipcall/hipcall_deepgram) - Unofficial Deepgram API Wrapper written in Elixir.
- [HipcallOpenai](https://github.com/hipcall/hipcall_openai) - Unofficial OpenAI API Wrapper written in Elixir.
- [HipcallWhichtech](https://github.com/hipcall/hipcall_whichtech) - Find out what the website is built with.

