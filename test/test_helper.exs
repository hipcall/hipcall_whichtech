defmodule HipcallWhichtech.TestServer do
  @moduledoc false

  # A Bandit-backed HTTP test server that serves a pre-queued list of
  # `{status, headers, body}` responses in order — one per incoming request.
  # Defined here so it's loaded once at test startup and available to all
  # test files without a separate compile path.

  @behaviour Plug

  @impl Plug
  def init(queue_pid), do: queue_pid

  @impl Plug
  def call(conn, queue_pid) do
    case Agent.get_and_update(queue_pid, &pop/1) do
      :empty ->
        Plug.Conn.send_resp(conn, 500, "no response queued")

      {status, headers, body} ->
        conn
        |> put_headers(headers)
        |> Plug.Conn.send_resp(status, body)
    end
  end

  defp pop([]), do: {:empty, []}
  defp pop([head | tail]), do: {head, tail}

  defp put_headers(conn, headers) do
    Enum.reduce(headers, conn, fn {k, v}, c -> Plug.Conn.put_resp_header(c, k, v) end)
  end

  @doc """
  Starts a Bandit HTTP server on a random port bound to 127.0.0.1, returning
  `{base_url, stop_fn}`.

  `responses` may be either:

    * a list of `{status, headers, body}` tuples, or
    * a 1-arity function that receives the base URL (e.g.
      `"http://127.0.0.1:54321"`) and returns such a list. Use this when a
      response needs to reference the server's own URL — for example a
      redirect with an absolute `Location` header pointing back at itself.
  """
  @spec start(
          [{pos_integer(), [{String.t(), String.t()}], binary()}]
          | (String.t() -> [{pos_integer(), [{String.t(), String.t()}], binary()}])
        ) :: {String.t(), (-> :ok)}
  def start(responses) do
    {:ok, queue_pid} = Agent.start_link(fn -> [] end)

    {:ok, server} =
      Bandit.start_link(
        plug: {__MODULE__, queue_pid},
        port: 0,
        ip: {127, 0, 0, 1},
        startup_log: false
      )

    {:ok, {_ip, port}} = ThousandIsland.listener_info(server)
    base_url = "http://127.0.0.1:#{port}"

    resolved =
      case responses do
        fun when is_function(fun, 1) -> fun.(base_url)
        list when is_list(list) -> list
      end

    Agent.update(queue_pid, fn _ -> resolved end)

    stop = fn ->
      if Process.alive?(server), do: Supervisor.stop(server)
      if Process.alive?(queue_pid), do: Agent.stop(queue_pid)
      :ok
    end

    {base_url, stop}
  end
end

ExUnit.start()
