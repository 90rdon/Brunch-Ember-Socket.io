authorizationCodes = exports ? this

exports.find = (key, done) ->
  code = authorizationCodes.codes[key]
  done null, code

exports.save = (code, clientID, redirectURI, userID, done) ->
  authorizationCodes.codes[code] = { clientID: clientID, redirectURI: redirectURI, userID: userID }
  done null