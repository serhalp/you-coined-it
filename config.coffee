convict = require 'convict'

config = convict
  env:
    doc: 'Node environment currently running'
    format: ['development', 'test', 'production']
    default: 'development'
    env: 'NODE_ENV'

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
