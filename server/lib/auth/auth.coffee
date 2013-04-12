config                  = require('../../../config').config
passport                = require 'passport'
TwitterStrategy         = require('passport-twitter').Strategy
# LocalStrategy           = require('passport-local').Strategy
# BasicStrategy           = require('passport-http').BasicStrategy
# ClientPasswordStrategy  = require('passport-oauth2-client-password').Strategy
# BearerStrategy          = require('passport-http-bearer').Strategy
db                      = require '../db'

# # Local Strategy
# passport.use new LocalStrategy (username, password, done) ->
#   db.users.findByUsername username, (err, user) ->
#     done err if err
#     done null, false if not user?
#     done null, false if user.password isnt password
#     done null, user

# passport.serializeUser (user, done) ->
#   console.log 'serializing user'
#   done null, user

# passport.deserializeUser (id, done) ->
#   db.users.find id, (err, user) ->
#     done err, user

passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (obj, done) ->
  done null, obj  

# # BasicStrategy & ClientPasswordStrategy
# passport.use new BasicStrategy (username, password, done) ->
#   db.clients.findByClientId username, (err, client) ->
#     done err if err
#     done null, false if not client?
#     done null, false if client.clientSecret isnt password
#     done null, client

# passport.use new ClientPasswordStrategy (clientId, clientSecret, done) ->
#   db.clients.findByClientId clientId, (err, client) ->
#     done err if err
#     done null, false if not client?
#     done null, false if client.clientSecret isnt clientSecret
#     done null, client

# # BearerStrategy
# passport.use new BearerStrategy (accessToken, done) ->
#   db.accessToken.find accessToken, (err, token) ->
#     done err if err
#     done null, false if not token?

#     db.users.find token.userID, (err, user) ->
#       done err if err
#       done null, false if not user?
#       # need to implement restrict scopes before production 
#       info = { scope: '*' }
#       done null, user, info

# Twitter Strategy
passport.use new TwitterStrategy {
  consumerKey: config.auth.Twitter.CONSUMER_KEY
  consumerSecret: config.auth.Twitter.CONSUMER_SECRET
  callbackURL: config.auth.Twitter.callbackURL
}, 
(token, tokenSecret, profile, done) ->
  process.nextTick ->
    done null, profile