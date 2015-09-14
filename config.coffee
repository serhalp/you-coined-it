convict = require 'convict'

config = convict
  reddit:
    oauth:
      key:
        doc: 'Reddit Oauth key'
        format: '*'
        default: null
        env: 'REDIT_OAUTH_KEY'
      secret:
        doc: 'Reddit secret'
        format: '*'
        default: null
        env: 'REDIT_SECRET'
      username:
        doc: 'Reddit username'
        format: '*'
        default: null
        env: 'REDIT_USERNAME'
      password:
        doc: 'Reddit password'
        format: '*'
        default: null
        env: 'REDIT_PASSWORD'

module.exports = config.root()
