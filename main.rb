require 'rubygems'
require 'bundler/setup'

Bundler.require

require './mumblebot/mumblebot'
require './mumblebot/url2img'
require './mumblebot/autoafk'

Mumblebot.connect
