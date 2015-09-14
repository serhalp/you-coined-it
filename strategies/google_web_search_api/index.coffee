Promise = require 'bluebird'

cse = require('googleapis').customsearch('v1').cse
Promise.promisifyAll cse, {suffix: 'Promised'}

Strategy = require '../strategy'
config = require './config'

module.exports = class GoogleWebSearchAPI extends Strategy
  isNeologism: (word) ->
    Promise.try ->
      console.log "Checking Google for #{word}..."

    .then ->
      query = "\"#{word}\""
      cse.listPromised(auth: config.apiKey, cx: config.cseId, q: query)

    .spread (result) ->
      result.searchInformation.totalResults is 0

  # no-op
  learn: (word) ->
    Promise.resolve()
