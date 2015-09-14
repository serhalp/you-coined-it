convict = require 'convict'

config = convict
  apiKey:
    doc: 'Google API key'
    format: '*'
    default: null
    env: 'GOOGLE_API_KEY'
  cseId:
    doc: 'Google Custom Search Engine ID'
    format: '*'
    default: null
    env: 'GOOGLE_CSE_ID'

module.exports = config.root()
