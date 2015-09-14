Promise = require 'bluebird'

cse = require('googleapis').customsearch('v1').cse
Promise.promisifyAll cse, {suffix: 'Promised'}

Strategy = require '../strategy'
config = require './config'

module.exports = class GoogleWebSearchAPI extends Strategy
  constructor: ({logger}) ->
    @logger = logger.child strategy: 'google_web_search_api'

  isNeologism: (word) ->
    Promise.try =>
      @logger.debug {word}, 'Looking word up via Google API'

    .then ->
      query = "\"#{word}\""
      cse.listPromised(auth: config.apiKey, cx: config.cseId, q: query)

    .spread (result) ->
      result.searchInformation.totalResults is 0

  # no-op
  learn: (word) ->
    Promise.resolve()
