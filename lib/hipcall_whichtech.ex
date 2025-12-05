defmodule HipcallWhichtech do
  @moduledoc """
  Documentation for `HipcallWhichtech`.
  """

  @type url() :: String.t() | URI.t()

  @detect_schema [
    exclude: [
      type: {:list, :atom},
      doc: """
      A list of detector which are exclude
      """,
      default: []
    ],
    only: [
      type: {:list, :atom},
      doc: """
      Detector that only look
      """,
      default: []
    ]
  ]

  @detectors [
    %{
      name: :alotech,
      module: HipcallWhichtech.Detector.AloTech,
      categories: [:chat]
    },
    %{
      name: :bitrix24,
      module: HipcallWhichtech.Detector.Bitrix24,
      categories: [:chat, :crm]
    },
    %{
      name: :crisp,
      module: HipcallWhichtech.Detector.Crisp,
      categories: [:chat]
    },
    %{
      name: :eticaretkur,
      module: HipcallWhichtech.Detector.Eticaretkur,
      categories: [:ecommerce]
    },
    %{
      name: :hipcallchat,
      module: HipcallWhichtech.Detector.HipcallChat,
      categories: [:chat]
    },
    %{
      name: :hubspot,
      module: HipcallWhichtech.Detector.Hubspot,
      categories: [:crm]
    },
    %{
      name: :ideasoft,
      module: HipcallWhichtech.Detector.Ideasoft,
      categories: [:ecommerce]
    },
    %{
      name: :jivochat,
      module: HipcallWhichtech.Detector.Jivochat,
      categories: [:chat]
    },
    %{
      name: :ikas,
      module: HipcallWhichtech.Detector.Ikas,
      categories: [:ecommerce]
    },
    %{
      name: :kommo,
      module: HipcallWhichtech.Detector.Kommo,
      categories: [:chat, :crm]
    },
    %{
      name: :platinmarket,
      module: HipcallWhichtech.Detector.Platinmarket,
      categories: [:ecommerce]
    },
    %{
      name: :shopify,
      module: HipcallWhichtech.Detector.Shopify,
      categories: [:ecommerce]
    },
    %{
      name: :tawk,
      module: HipcallWhichtech.Detector.Tawk,
      categories: [:chat]
    },
    %{
      name: :ticimax,
      module: HipcallWhichtech.Detector.Ticimax,
      categories: [:ecommerce]
    },
    %{
      name: :tidio,
      module: HipcallWhichtech.Detector.Tidio,
      categories: [:chat]
    },
    %{
      name: :tsoft,
      module: HipcallWhichtech.Detector.Tsoft,
      categories: [:ecommerce]
    },
    %{
      name: :webflow,
      module: HipcallWhichtech.Detector.Webflow,
      categories: [:cms]
    },
    %{
      name: :woocommerce,
      module: HipcallWhichtech.Detector.Woocommerce,
      categories: [:ecommerce]
    },
    %{
      name: :wordpress,
      module: HipcallWhichtech.Detector.Wordpress,
      categories: [:cms]
    },
    %{
      name: :wix,
      module: HipcallWhichtech.Detector.Wix,
      categories: [:chat, :cms]
    },
    %{
      name: :zendesk,
      module: HipcallWhichtech.Detector.Zendesk,
      categories: [:chat, :crm]
    }
  ]

  @doc """
  Detect a website tech

  ## Examples

      iex> {:ok, html_body} = HipcallWhichtech.request("https://www.bulutfon.com/")
      iex> HipcallWhichtech.detect(html_body)
      ...> {:ok, [:wordpress]}

      iex> {:ok, html_body} = HipcallWhichtech.request("https://woo.com/")
      iex> HipcallWhichtech.detect(html_body)
      ...> {:ok, [:wordpress, :woocommerce]}

  You can set the excluded detectors. For example `exclude: [:woocommerce]` options.

      iex> {:ok, html_body} = HipcallWhichtech.request("https://woo.com/")
      iex> HipcallWhichtech.detect(html_body, exclude: [:woocommerce])
      ...> {:ok, [:wordpress]}

  You can also set one or more detectors. For example `only: [:wordpress]` options.
  Package check only `wordpress` with this option.

      iex> {:ok, html_body} = HipcallWhichtech.request("https://woo.com/")
      iex> HipcallWhichtech.detect(html_body, only: [:wordpress])
      ...> {:ok, [:wordpress]}

  ## Arguments

    - `html_body` : html code
    - `options` : list

  ## Options

  #{NimbleOptions.docs(@detect_schema)}

  ## Raises

    - Raise `NimbleOptions.ValidationError` if params are not valid.

  ## Returns

    - `{:ok, list()}`
    - `{:error, any()}`

  """
  @spec detect(html_body :: String.t(), options :: Keyword.t()) ::
          {:ok, list()} | {:error, any()}
  def detect(html_body, options \\ []) do
    NimbleOptions.validate!(options, @detect_schema)

    with {:ok, detectors} <- set_detectors(options),
         result <- build(html_body, detectors) do
      {:ok, result}
    else
      {:error, exception} ->
        {:error, exception}
    end
  end

  @doc """
  Request and get html body from an URL.

  ## Examples

      iex> {:ok, html_body} = request("https://woo.com/")

  ## Arguments

    - url: String

  ## Options

    - There is no option.

  ## Raises

    - There is no exception.

  ## Returns

    - `{:ok, binary()}`
    - `{:error, any()}`
  """
  @spec request(url()) :: {:ok, String.t()} | {:error, any()}
  def request(url) do
    case Finch.build(:get, url) |> Finch.request(HipcallWhichtechFinch) do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Finch.Response{status: status}} ->
        {:error, "Received status #{status}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp set_detectors(options) do
    detectors =
      @detectors
      |> exclude_detectors(Keyword.get(options, :exclude))
      |> only_detectors(Keyword.get(options, :only))

    {:ok, detectors}
  end

  defp exclude_detectors(detectors, nil), do: detectors
  defp exclude_detectors(detectors, []), do: detectors

  defp exclude_detectors(detectors, only)
       when is_list(only) and is_list(detectors) do
    Enum.reject(detectors, fn detector ->
      detector[:name] in only
    end)
  end

  defp only_detectors(detectors, nil), do: detectors
  defp only_detectors(detectors, []), do: detectors

  defp only_detectors(detectors, exclude)
       when is_list(exclude) and is_list(detectors) do
    Enum.reject(detectors, fn detector ->
      detector[:name] not in exclude
    end)
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
