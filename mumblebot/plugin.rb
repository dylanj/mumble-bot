module Mumblebot
  class Plugin
    def initialize(client, options)
      @client = client
      @options = options

      setup()
    end

    def setup
      # implement me
    end
  end
end
