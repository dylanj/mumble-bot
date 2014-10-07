#Mumblebot

##a bot framework for mumble written in ruby

Mumblebot is a framework that nicely exposes events from mumble so that you can interact with or control a mumber server.

###Built in plugins

Plugin Name | Done|Description
----------- | ----------- | ----------
URL to Image | Yes |Converts URLs to images into thumbnails and posts them in chat.
AutoAFK | No | Moves AFK users to specified channel and back to their original channel when they come back.
Server Control | No | Kick/Ban users from the chatroom

###Todo

- [ ] Nice interface for querying channels/users
- [ ] Support all events
- [ ] Tests
- [X] Readme

Heavy lifting provided by [mumble-ruby](https://github.com/perrym5/mumble-ruby)
