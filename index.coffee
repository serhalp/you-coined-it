_ = require 'lodash'
Promise = require 'bluebird'
Snoocore = require 'snoocore'

config = require './config'
logger = require './logger'
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

dictionary = new EnglishDictionary {logger}

googleWebSearchAPI = new GoogleWebSearchAPI {logger}

reddit('/new').listing limit: 50

.then (result) ->
  posts = _.pluck result.children, 'data'

  Promise.map posts, (post) ->
    reddit('/comments/$article').listing {$article: post.id, limit: 3}, {listingIndex: 1}
    .then (result) ->
      comments = _.pluck result.children, 'data'

      if comments.length is 0
        logger.debug {postId: post.id}, 'No comments on post'

      for comment in comments
        wordPattern = /[a-zA-Z]+/g

        tokens = while (matches = wordPattern.exec comment.body) isnt null
          matches[0]

        if tokens.length is 0
          logger.debug {commentId: comment.id}, 'No tokens in comment'

        Promise.filter tokens, dictionary.isNeologism.bind(dictionary)
        .then (words) ->
          words = _.uniq words
          logger.debug {words}, 'Decided which words to look up'

          Promise.map words, (word) ->
            googleWebSearchAPI.isNeologism word
            .then (isNeologism) ->
              if isNeologism
                logger.info {author: comment.author, word}, 'New word coined'
              else
                dictionary.learn word

          , {concurrency: 2} # easy on Google API

.catch (err) ->
  logger.error {err}, 'Oh no.'
