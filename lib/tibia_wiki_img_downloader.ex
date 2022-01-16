defmodule TibiaWikiImgDownloader do
  defp get_path_download_images(), do: "images_downloaded/"
  # defp get_max_file_size(), do: 1024 * 5
  defp desired_quantity_of_images(), do: 25

  defp get_search_word(), do: "Demônios"
  defp get_base_search_url(), do: "https://www.tibiawiki.com.br"
  defp get_final_search_url(), do: get_base_search_url() <> "/wiki/" <> get_search_word()


  defp request_body(url) do
    case HTTPoison.get url do
      {:ok,    %HTTPoison.Response{status_code: 200, body: body}} -> body
      {:ok,    %HTTPoison.Response{status_code: 404}} -> IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} -> IO.inspect reason
    end
  end

  defp filter_images_from_body(body) do
    get_floki_document(body)
    |> Floki.find("tbody")
    |> Floki.find("td")
    |> Floki.find("img")
  end

  defp get_floki_document(body) do
    case Floki.parse_document(body) do
      {:ok, document} -> document
    end
  end

  defp filter_desired_quantity(img_tags), do:
    img_tags |> Enum.take(desired_quantity_of_images())

  defp download_each_image_from_list(img_tags) do
    Enum.each(img_tags, fn img_tag ->
      img_tag |> download_image_from_tag()
    end)
  end

  defp download_image_from_tag(img_tag) do
    img_tag
    |> filter_tag_attributes()
    |> get_download_url_from_image_tag_attributes()
    |> request_download_from_img_url()
  end

  defp filter_tag_attributes(tag) do
    case tag do
      { _tag_name, tag_attributes, _tag_content } -> tag_attributes
      _ -> IO.puts "Tag Not Found."
    end
  end

  defp get_download_url_from_image_tag_attributes(tag_attributes) do
    [ _class | [ src | _other_attributes ] ] = tag_attributes
    { _name, value } = src
    get_base_search_url() <> value
  end

  defp request_download_from_img_url(url) do
    url
    |> get_storage_path_with_filename()
    |> File.write!(request_download(url))
  end

  defp get_storage_path_with_filename(url) do
    get_path_download_images() <> get_file_name_from_url(url)
  end

  defp get_file_name_from_url(url) do
    url
    |> String.split("/")
    |> List.last()
  end

  defp request_download(url) do
    HTTPoison.get!(url,
      [ "User-Agent": "Mozilla/5.0" ],
      [
        recv_timeout: 10_000,
        follow_redirect: true
      ]
    ).body
  end


  def run() do
    get_final_search_url()
    |> request_body()
    |> filter_images_from_body()
    |> filter_desired_quantity()
    |> download_each_image_from_list()
  end
end
