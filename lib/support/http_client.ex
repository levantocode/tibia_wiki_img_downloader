defmodule Support.HttpClient do
  require Logger

  def request_body(url, header, opts) do
    HTTPoison.get!(url, resolve_header(header), resolve_options(opts))
    |> handle_response()
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: body
  defp handle_response({:ok, %HTTPoison.Response{status_code: 404}}), do: Logger.warn("Not found :(")
  defp handle_response({:error, %HTTPoison.Error{reason: reason}}), do: Logger.debug(reason)
  defp handle_response(any_error), do: Logger.error(inspect(any_error))

  defp resolve_header(:mozilla), do: ["User-Agent": "Mozilla/5.0"]
  defp resolve_header(_), do: []

  defp resolve_options(:long_timeout), do: [recv_timeout: 10_000, follow_redirect: true]
  defp resolve_options(_), do: []
end
