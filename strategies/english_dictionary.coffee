Promise = require 'bluebird'
_ = require 'lodash'
wordlist = require('wordlist-english').english

Strategy = require './strategy'

module.exports = class EnglishDictionary extends Strategy
  constructor: ->
    super
    @entries = _.zipObject wordlist, _.times(wordlist.length, _.constant true)
    @add 'reddit'
    @add 'subreddit'
    @add 'askreddit'

  contains: (word) ->
    word.length < 5 or word.toLowerCase() of @entries

  add: (word) ->
    @entries[word] = true

  isNeologism: (word) ->
    console.log "Checking dictionary for #{word}..."
    Promise.resolve not @contains word

  learn: (word) ->
    @add word
    console.log "Learned #{word}"
    Promise.resolve()
