module Mumblebot
  class Bot
    def initialize(config)
      @callbacks = {}
      @config = config

      @client = Mumble::Client.new(nil) do |config|
        config.host = address()
        config.port = port()
        config.username = username()

        config.cert_dir = cert_dir()
        config.country_code = country_code()
        config.organization = organization()
        config.organization_unit = organization_unit()
      end

      load_plugins()
      generate_callbacks()
    end

    def connect
      @client.connect()
    end

    def disconnect
      @client.disconnect()
    end

    private

    def events
      Mumble::Messages.all_types.map { |event| "on_#{event}" }
    end

    def generate_callbacks
      events.each do |event|
        @client.public_send(event) do |*args|
          call_plugin_handler(event, *args)
        end
      end
    end

    def load_plugins
      plugin_configs = @config[:plugins]
      plugin_configs.each do |name, options|
        begin
          require file_name = "plugins/#{name.downcase}"

          plugin = Util.constantize(name).new(@client, options)

          events.each do |event|
            add_plugin_handler(event, plugin)
          end

          puts "Loaded plugin \"#{name}\""
        rescue LoadError => exception
          puts "Failed to require file \"#{file_name}\" for plugin \"#{name}\": #{exception.message}"
        rescue NameError => exception
          puts "Failed to load plugin \"#{name}\": #{exception.message}"
        end
      end
    end

    def add_plugin_handler(event, plugin)
      if plugin.respond_to?(event)
        @callbacks[event] ||= []
        @callbacks[event] << plugin
      end
    end

    def call_plugin_handler(event, *args)
      plugins = @callbacks[event]
      return unless plugins

      plugins.each do |plugin|
        plugin.public_send(event, @client, *args)
      end
    end

    def address
      @config[:server][:address] || raise("specify an address to connect to in bot.yml")
    end

    def username
      @config[:server][:username] || "lazy-mumble-bot"
    end

    def port
      @config[:server][:port] || 64738
    end

    def cert_dir
      @config[:server][:cert_dir] || './certs'
    end

    def country_code
      @config[:server][:country_code] || 'CA'
    end

    def organization
      @config[:server][:org] || 'mumblebot'
    end

    def organization_unit
      @config[:server][:org_unit] || 'ruby'
    end
  end
end
