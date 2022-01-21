defmodule TibiaWikiImgDownloader do
  alias Support.HtmlParser
  alias Support.HttpClient
  alias Support.FileDownloader
  alias Support.Contants
  require Logger
  # defp get_max_file_size(), do: 1024 * 5

  def run do
    get_final_search_url()
    |> HttpClient.request_body(:default, :default)
    |> HtmlParser.filter_images_from_body()
    |> Enum.take(Contants.get_img_qty())
    |> FileDownloader.download_each_image_from_list()
  end

  defp get_final_search_url, do: Contants.get_base_url() <> "/wiki/" <> Contants.get_default_topic()
end
