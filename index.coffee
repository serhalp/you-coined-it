_ = require 'lodash'
Promise = require 'bluebird'
Snoocore = require 'snoocore'

config = require './config'
{EnglishDictionary, GoogleWebSearchAPI} = require './strategies'

reddit = new Snoocore
  userAgent: "snoocore:you-coined-it:v0.0.1 (by /u/#{config.reddit.owner.username})"
  oauth:
    type: 'script'
    key: config.reddit.oauth.key
    secret: config.reddit.oauth.secret
    username: config.reddit.oauth.username
    password: config.reddit.oauth.password
    scope: ['read', 'submit']

dictionary = new EnglishDictionary()

googleWebSearchAPI = new GoogleWebSearchAPI()

reddit('/new').listing limit: 50

.then (result) ->
  posts = _.pluck result.children, 'data'

  Promise.map posts, (post) ->
    reddit('/comments/$article').listing {$article: post.id, limit: 3}, {listingIndex: 1}
    .then (result) ->
      comments = _.pluck result.children, 'data'

      for comment in comments
        wordPattern = /[a-zA-Z]+/g

        tokens = while (matches = wordPattern.exec comment.body) isnt null
          matches[0]

        Promise.filter tokens, dictionary.isNeologism.bind(dictionary)
        .then (words) ->
          words = _.uniq words
          console.log 'Decided which words to look up', words

          Promise.map words, (word) ->
            googleWebSearchAPI.isNeologism word
            .then (isNeologism) ->
              if isNeologism
                console.log "User #{comment.author} just coined '#{word}'!"
              else
                dictionary.learn word

          , {concurrency: 2} # easy on Google API

.catch (err) ->
  console.error {err}, 'Oh no.'
