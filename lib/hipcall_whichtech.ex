defmodule HipcallWhichtech do
  @moduledoc """
  Documentation for `HipcallWhichtech`.
  """

  @detectors [
    %{
      name: :wordpress,
      module: HipcallWhichtech.Detector.Wordpress,
      categories: [:cms]
    },
    %{
      name: :woocommerce,
      module: HipcallWhichtech.Detector.Woocommerce,
      categories: [:ecommerce]
    },
    %{
      name: :hubspot,
      module: HipcallWhichtech.Detector.Hubspot,
      categories: [:crm]
    },
    %{
      name: :shopify,
      module: HipcallWhichtech.Detector.Shopify,
      categories: [:ecommerce]
    }
  ]

  @doc """
  Detect a website tech

  ## Examples

      iex> HipcallWhichtech.detect("https://woo.com/")
      ...> {:ok, [:wordpress, :woocommerce]}
      iex> HipcallWhichtech.detect("https://www.bulutfon.com/")
      ...> {:ok, [:wordpress]}

  ## Arguments

  - `url` : a valid url
  - `options` : list

  ## Options

  TODO

  ## Raises

  There is no exception.

  ## Returns

  - `{:ok, list()}`
  - `{:error, any()}`

  """
  @spec detect(url :: String.t(), options :: Keyword.t()) ::
          {:ok, list()} | {:error, any()}
  def detect(url, options \\ []) do
    with {:ok, html_body} <- html(url),
         {:ok, detectors} <- set_detectors(options),
         result <- build(html_body, detectors) do
      {:ok, result}
    else
      {:error, exception} ->
        {:error, exception}
    end
  end

  defp html(url) do
    case Finch.build(:get, url) |> Finch.request(HipcallWhichtechFinch) do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Finch.Response{status: status}} ->
        {:error, "Received status #{status}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp set_detectors(_options \\ []) do
    {:ok, @detectors}
  end

  defp build(html_body, detectors) do
    detectors
    |> Enum.reduce([], fn detector, acc ->
      case detector.module.detect(html_body) do
        false ->
          acc

        true ->
          acc ++ [detector.name]
      end
    end)
  end
end
