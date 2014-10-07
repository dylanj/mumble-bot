module Mumblebot
  class Bot

    def initialize(config)
      @plugins = {}
      @client = nil
      @config = config

      load_plugins(config)

      @client = Mumble::Client.new(nil) do |config|
        config.host = address()
        config.port = port()
        config.username = username()
      end

      @client.on_connected do
        on_connected(@client, nil)
      end

      @client.on_text_message do |message|
        on_text_message(@client, message)
      end
    end

    def load_plugins(config)
      events = [:on_connected, :on_disconnect, :on_text_message]

      plugin_configs = config[:plugins]
      plugin_configs.each do |name, options|
        plugin = Util.constantize(name).new(options)

        events.each do |event|
          add_plugin_handler(plugin, event)
        end
      end

      # try *args, args[0], args[1]??
      events.each do |event|
        self.class.send(:define_method, event) do |client, message|
          call_plugin_handler(event, client, message)
        end
      end
    end

    def call_plugin_handler(handler, client, message)
      @plugins[handler].each do |plugin|
        plugin.public_send(handler, client, message)
      end
    end

    def add_plugin_handler(plugin, handler)
      if plugin.respond_to?(handler)
        @plugins[handler] ||= []
        @plugins[handler] << plugin
      end
    end

    def connect
      @client.connect()
    end

    def disconnect
      @client.disconnect()
    end

    private

    def address
      @config[:server][:address] || raise("specify an address to connect to in bot.yml")
    end

    def username
      @config[:server][:username] || "lazy-mumble-bot"
    end

    def port
      @config[:server][:port] || 64738
    end
  end
end
