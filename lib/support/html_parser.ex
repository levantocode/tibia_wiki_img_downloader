defmodule Support.HtmlParser do
  def filter_images_from_body(body) do
    get_floki_document(body)
    |> Floki.find("tbody")
    |> Floki.find("td")
    |> Floki.find("img")
  end

  defp get_floki_document(body) do
    {:ok, document} = Floki.parse_document(body)
    document
  end
end
