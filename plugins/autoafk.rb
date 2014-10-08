require 'RMagick'
require 'uri'

class AutoAFK < Mumblebot::Plugin
  DEFAULT_IDLETIME = 10
  DEFAULT_CHANNEL = 'AFK'

  def setup
    @channel_name = @options[:channel] || 'AFK'
    @idletime = @options[:idletime] || 10
  end

  def on_connected(client)
    @users = client.users
    @channel = client.find_channel(@channel_name)
  end
end

