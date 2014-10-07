require 'rubygems'
require 'bundler/setup'

Bundler.require
require './mumblebot/util'
require './mumblebot/url2img'
require './mumblebot/autoafk'
require './mumblebot/bot'

module Mumblebot
  def self.start
    configs = YAML.load_file('./bot.yml')
    configs = Util.symbolize_keys(configs)

    configs.each do |_, config|
      bot = Mumblebot::Bot.new(config)
      bot.connect()
    end

    while true
      sleep 1
    end
  end
end

Mumblebot.start
