$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../mumblebot")

require 'rubygems'
require 'bundler/setup'

Bundler.require

require 'mumblebot/util'
require 'mumblebot/bot'
require 'mumblebot/plugin'

module Mumblebot
  def self.start
    configs = YAML.load_file('./bot.yml')
    configs = Util.symbolize_keys(configs)

    configs.each do |_, config|
      bot = Mumblebot::Bot.new(config)
      bot.connect()
    end

    loop {}
  end
end

Mumblebot.start
