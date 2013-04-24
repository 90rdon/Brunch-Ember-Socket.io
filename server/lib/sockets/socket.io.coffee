config                  = require('../../../config').config
defaultConfig           = config.socket.default
heroku                  = config.socket.heroku
io                      = require 'socket.io'
cookie                  = require('express/node_modules/cookie')
utils                   = require('express/node_modules/connect').utils
express                 = require 'express'
passport                = require 'passport'
# Session                 = require('express/node_modules/connect').middleware.session.Session
SessionSockets          = require 'session.socket.io'

exports.startSocket     = (server, sessionConfig) ->
  # --- start socket.io server by listening to expre  ss server --- 
  sio                   = io.listen server
  sessionStore          = sessionConfig['store']
  cookieParser          = express.cookieParser sessionConfig['secret']
  sockets               = new SessionSockets sio, sessionStore, cookieParser, sessionConfig['key']

  # --- environment config ---
  sio.configure         'development', ->
    console.log         '--- socket.io is running on development environment'
    sio.set             'log level', 5
    sio.set             'transports', defaultConfig.transports
    sio.set             'polling duration', defaultConfig.duration

  sio.configure         'production', ->
    console.log         '--- socket.io is running on heroku environment'
    sio.enable          'browser client minifaction'
    sio.enable          'browser client etag'
    sio.enable          'browser client gzip'
    sio.set             'log level', 1 
    sio.set             'transports', heroku.transports
    sio.set             'polling duration', heroku.duration

  # ---------------------
  # --- authorization ---
  # ---------------------
  sio.set               'authorization', (handshake, accept) ->
    console.log 'handshake, lets take a look'
    # console.dir handshake 
    if handshake.headers.cookie?
      # first parse the cookie into a half-formed object
      parsedCookie            = cookie.parse handshake.headers.cookie

      # verify the signature of the session cookie
      handshake.cookie        = utils.parseSignedCookies parsedCookie, sessionConfig['secret']
      
      # set session ID from cookie
      handshake.sessionID     = handshake.cookie[sessionConfig['key']]
      # set our sessionStore for later use
      handshake.sessionStore  = sessionStore

      # session store
      sessionStore.get  handshake.sessionID, (err, session) ->
        return accept   'Error in session store. <-socket.io authorization->', false if err
        return accept   'Session not found.', false if not session?
        return accept   null, true
    else 
      # check if this connection is made from the server
      return accept     null, true if handshake.query.secret_keyword? and handshake.query.secret_keyword is sio.secret_keyword
      return accept     'Cookie not found.', false

  # ------------------
  # --- namespaces ---
  # ------------------
  # root 
  sockets.on            'connection', (err, socket, session) ->
    handshake           = socket.handshake
    console.log         'A socket with sessionID ' + handshake.sessionID + ' has connected.'

    # keep connection open
    intervalID          = setInterval ->
      if handshake? and handshake.session?
        handshake.session.reload ->
          handshake.session.touch().save()
    , 60 * 1000

    socket.on           'disconnect', ->
      console.log       'A socket with sessionID ' + handshake.sessionID + ' disconnected.'
      clearInterval     intervalID

    socket.join         socket.handshake.sessionID
    
    session.name = 'yoyoyo'
    session.save()
    socket.send session.name

  # member
  sio.of('/member').authorization (handshake, accept) ->    
      accept null, true

    .on 'connection', (socket) ->
      # --- channels ---
      socket.emit 'membermsg', { info: 'OAuth 2.0 server' }

