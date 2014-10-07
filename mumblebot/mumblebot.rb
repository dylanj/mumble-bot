require 'rubygems'
require 'bundler/setup'

require 'RMagick'
require 'uri'

Bundler.require

module Mumblebot
  def self.connect
    cli = Mumble::Client.new('zqz.ca') do |config|
      config.username = 'O'
    end

    cli.on_connected do
      cli.me.mute
      cli.me.deafen
    end

    cli.on_text_message do |message|
      Url2Img.listen(cli, message)
    end

    cli.connect

    while true
      sleep 1
    end
  end
end
