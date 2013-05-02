oauth2orize     = require 'oauth2orize'
passport        = require 'passport'
# login           = require 'connect-ensure-login'
db              = require '../db'
utils           = oauth2orize.utils
crypto          = require 'crypto'
models          = require '../../models'

# create OAuth 2.0 server
server = oauth2orize.createServer()



# --- serializing and deserializing the client
server.serializeClient (client, done) ->
  done null, client._id

server.deserializeClient (_id, done) ->
  models.client.findById _id, (err, client) ->
    return done err   if err
    done null, client



# --- grant types ----
server.grant oauth2orize.grant.code (client, redirectURI, user, ares, done) ->
  now   = new Date().getTime()
  code  = crypto.createHmac('sha1', 'access_token')
    .update([client.id, now].join())
    .digest('hex')

  authorizeCode = new models.authorizationCode
    code:           code
    client_id:      client.id
    redirect_uri:   redirectURI
    user_id:        client.user_id
    scope:          ares.scope

  authorizeCode.save (err) ->
    return done err   if err
    done null, code

server.grant oauth2orize.grant.code (client, user, ares, done) ->
  now   = new Date().getTime()
  token = crypto.createHmac('sha1', 'access_token')
    .update([client.id, now].join())
    .digest('hex')

  accessToken = new models.accessToken
    oauth_token:    token
    user_id:        client.user_id
    client_id:      client._id
    scope:          ares.scope

  accessToken.save (err) ->
    return done err   if err
    done null, token

# --- exchange types ---
server.exchange oauth2orize.exchange.code (client, code, redirectURI, done) ->
  models.authorizationCode.findOne { code: code }, (err, code) ->
    return done err           if err
    return done null, false   if not code
    return done null, false   if code.client_id.toString() is not client._id.toString()
    return done null, false   if code.redirect_uri is not redirectURI 

    now   = new Date().getTime()
    token = crypto.createHmac('sha1', 'access_token')
      .update([client.id, now].join())
      .digest('hex') 

    accessToken = new models.accessToken
      oauth_token:  token
      user_id:      code.user_id
      client_id:    client._id
      scope:        code.scope

    accessToken.save (err) ->
      return done err       if err
      done null, token

ensureLoggedIn = ->
  (req, res, next) ->
    return res.redirect '/login'  if not req.session.user? or not req.session.user.id?
    next()

# --- routes ---
exports.authorization = [
  ensureLoggedIn(),
  server.authorization (clientID, redirectURI, done) ->
    models.client.findById clientID, (err, client) ->
      return done err           if err
      return done null, false   if not client?
      return done null, false   if client.redirect_uri is not redirectURI
      done null, client, redirectURI,
  (req, res) ->
    res.json 
      transactionID:  req.oauth2.transactionID
      user:           req.user
      client:         req.oauth2.client
    # res.render 'dialog', { transacationID: req.oauth2.transactionID, user: req.user, client: req.oauth2.client }
]

exports.decision = [
  ensureLoggedIn(),
  server.decision()
]

exports.token = [
  passport.authenticate([ 'basic', 'oauth2-client-password' ], { session: false }),
  server.token(),
  server.errorHandler()
]


