require 'RMagick'
require 'uri'

class Fishbot::Url2Img
  IMAGE_SIZE = 200

  class Rekwezt
    include HTTParty
    default_timeout 4 # 4 seconds
  end

  def handle(cli, message)
    @cli = cli
    @message = message
    urls_in_message().each { |u| handle_url(u) }
  end

  def self.listen(cli, message)
    url2img = ::Fishbot::Url2Img.new
    url2img.handle(cli, message)
  end

  private

  def handle_url(url)
    begin
      response = Rekwezt.get(url)

      return unless supported_response?(response)

      thumb = create_thumbnail(response)
      channel_message = image_for_blob(thumb.to_blob)
    rescue ArgumentError
      channel_message = nil
    rescue Magick::ImageMagickError
      channel_message = "Failed to load image"
    end

    @cli.text_channel(target_id(), channel_message) if channel_message
  end

  def create_thumbnail(response)
    image = Magick::Image.from_blob(response.body).first
    resize_by_width(image, IMAGE_SIZE)
  end

  def target_id()
    ids = @message[:channel_id] || @message[:tree_id]
    ids.first
  end

  def urls_in_message()
    URI.extract(@message[:message]).uniq
  end

  def supported_response?(response)
    supported_mime_types.include?(response.headers['content-type'])
  end

  def supported_mime_types()
    ["image/jpeg", "image/png", "image/gif"]
  end

  def image_for_blob(blob)
    encoded_blob = Base64.encode64(blob)
    %[<img src="data:image/jpeg;charset=utf-8;base64,#{encoded_blob}"/>]
  end

  def resize_by_width(image, new_width)
    width = image.columns.to_f
    height = image.rows.to_f

    ratio = (new_width / width)
    new_height = ratio * height

    image.scale(new_width, new_height)
  end
end

