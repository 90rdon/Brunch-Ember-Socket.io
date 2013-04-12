accessTokens = exports ? this

exports.find = (key, done) ->
  token = accessTokens.tokens[key]
  done null, token

exports.save = (token, userID, clientID, done) ->
  accessTokens.tokens[token] = { userID: userID, clientID: clientID }
  done null