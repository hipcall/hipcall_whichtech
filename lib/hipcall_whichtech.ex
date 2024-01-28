defmodule HipcallWhichtech do
  @moduledoc """
  Documentation for `HipcallWhichtech`.
  """


  def html(url) do
    case Finch.build(:get, url) |> Finch.request(HipcallWhichtechFinch) do
      {:ok, %Finch.Response{status: 200, body: body, headers: _headers, trailers: _trailers}} ->
        {:ok, body}
      {:error, exception} ->
        {:error, exception}
    end
  end
end
