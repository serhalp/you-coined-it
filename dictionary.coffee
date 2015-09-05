_ = require 'lodash'
wordlist = require('wordlist-english').english

class Dictionary
  constructor: ->
    @entries = _.zipObject wordlist, _.times(wordlist.length, _.constant true)
    @add 'reddit'

  contains: (word) ->
    word.length < 5 or word.toLowerCase() of @entries

  add: (word) ->
    @entries[word] = true

module.exports = new Dictionary()
