bunyan = require 'bunyan'
PrettyStream = require 'bunyan-prettystream'

config = require './config'

streams = []

if config.env is 'development'
  prettyStream = new PrettyStream()
  prettyStream.pipe(process.stdout)
  streams.push {
    level: 'debug'
    type: 'raw'
    stream: prettyStream
  }

module.exports = bunyan.createLogger {
  name: 'you-coined-it'
  env: config.env
  streams
}
