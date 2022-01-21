defmodule Support.FileDownloader do
  alias Support.Contants
  alias Support.HttpClient

  def download_each_image_from_list(img_tags) do
    Enum.map(img_tags, fn img_tag ->
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
      {_tag_name, tag_attributes, _tag_content} -> tag_attributes
      _ -> IO.puts("Tag Not Found.")
    end
  end

  defp get_download_url_from_image_tag_attributes(tag_attributes) do
    {_name, value} =
      tag_attributes
      |> Enum.at(1)
      |> Enum.at(0)

    Contants.get_base_url() <> value
  end

  defp request_download_from_img_url(url) do
    url
    |> get_storage_path_with_filename()
    |> File.write!(request_download(url))
  end

  defp get_storage_path_with_filename(url) do
    Contants.get_download_path() <> get_file_name_from_url(url)
  end

  defp get_file_name_from_url(url) do
    url
    |> String.split("/")
    |> List.last()
  end

  defp request_download(url) do
    HttpClient.request_body(url, :mozilla, :long_timeout).body
  end
end
