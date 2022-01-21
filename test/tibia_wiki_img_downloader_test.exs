defmodule TibiaWikiImgDownloaderTest do
  use ExUnit.Case

  describe "run/0" do
    test "running good scenario, should download images" do
      # Para mockar isso tem a biblioteca mimic
      #      Mimic.mock(HTTPoison, :get!, fn  -> get_mocked_html_with_images() end)

      assert TibiaWikiImgDownloader.run() == :ok
    end
  end

  defp get_mocked_html_with_images do
    %HTTPoison.Response{status_code: 200, body: ""}
  end
end
