require 'rubygems'
require 'bundler/setup'

Bundler.require

require './fishbot/fishbot'
require './fishbot/url2img'
require './fishbot/autoafk'

Fishbot.connect
