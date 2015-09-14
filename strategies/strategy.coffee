###
Interface for a class implementing a strategy for determining whether a given
word is a neologism.
###

module.exports = class Strategy
  ###
  Whether the given word is a neologism or not.

  @param {String} word the requested word

  @return {Promise: Boolean}
  ###
  isNeologism: (word) ->
    throw new Error 'Abstract method not overridden, cannot be called'

  ###
  Teach this strategy that this word is not a neologism.  `isNeologism` should
  never respond with `true` after having learned a word.

  @param {String} word the non-neologism to learn and never forget

  @return {Promise} resolved when done learning
  ###
  learn: (word) ->
    throw new Error 'Abstract method not overridden, cannot be called'
