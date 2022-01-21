defmodule Support.Contants do
  @img_qty 5
  @base_url "https://www.tibiawiki.com.br"
  @download_path "images_downloaded/"
  @default_topic "Demônios"

  def get_img_qty, do: @img_qty
  def get_base_url, do: @base_url
  def get_download_path, do: @download_path
  def get_default_topic, do: @default_topic
end
