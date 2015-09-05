_ = require 'lodash'
Promise = require 'bluebird'
Snoocore = require 'snoocore'

cse = require('googleapis').customsearch('v1').cse
Promise.promisifyAll cse, {suffix: 'Promised'}

config = require './config'
dictionary = require './dictionary'

reddit = new Snoocore
  userAgent: 'snoocore:you-coined-it:v0.0.1 (by /u/AnHeroicHippo)'
  oauth:
    type: 'script'
    key: config.reddit.oauth.key
    secret: config.reddit.oauth.secret
    username: config.reddit.oauth.username
    password: config.reddit.oauth.password
    scope: ['read', 'submit']

reddit('/new').listing limit: 50

.then (result) ->
  posts = _.pluck result.children, 'data'

  Promise.map posts, (post) ->
    reddit('/comments/$article').listing {$article: post.id, limit: 3}, {listingIndex: 1}
    .then (result) ->
      comments = _.pluck result.children, 'data'

      for comment in comments
        words = []
        wordPattern = /[a-zA-Z]+/g

        while (matches = wordPattern.exec comment.body) isnt null
          [word, ...] = matches

          unless dictionary.contains word
            words.push word

        Promise.map words, (word) ->
          console.log "Checking Google for #{word}..."

          cse.listPromised(auth: config.google.apiKey, cx: config.google.cseId, q: word)
          .spread (result) ->
            if result.searchInformation.totalResults is 0
              console.log "User #{comment.author} just coined '#{word}'!"
            else
              dictionary.add word

        , {concurrency: 2} # easy on Google API

.catch (err) ->
  console.error {err}, 'Oh no.'
