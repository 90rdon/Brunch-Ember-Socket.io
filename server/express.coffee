sysPath               = require 'path'
http                  = require 'http'
express               = require 'express'
redis                 = require 'redis'
RedisStore            = require('connect-redis')(express)

exports.startExpress  = (port, base, path, callback) ->
  # --- session ---
  if process.env.REDISTOGO_URL?
    console.log '--- using Redis remote store'
    redisToGo         = require('url').parse(process.env.REDISTOGO_URL)
    pub               = redis.createClient(redisToGo.port, redisToGo.hostname)
    pub.auth          redisToGo.auth.split(':')[1]
    sub               = redis.createClient(redisToGo.port, redisToGo.hostname)
    sub.auth          redisToGo.auth.split(':')[1]
    client            = redis.createClient(redisToGo.port, redisToGo.hostname)
    client.auth       redisToGo.auth.split(':')[1]
  else
    console.log '--- using Redis local store'
    pub               = redis.createClient()
    sub               = redis.createClient()
    client            = redis.createClient()
  sessionStore        = new RedisStore {
    pub:     pub,
    sub:     sub,
    client:  client
  }
  sessionConfig       = {
    key:          'express.pid',
    secret:       process.env.CLIENT_SECRET || 'mysecret'
    store:        sessionStore,
    cookie:       { maxAge: 60 * 60 * 1000 }    
  }
  # --- core ---
  app                 = express()
  app.configure ->
    app.use           express.cookieParser()
    app.use           express.session sessionConfig
    app.use           base, express.static path
    app.all           '#{base}/*', (request, response) ->
      response.sendfile sysPath.join path, 'index.html'

  app.configure 'development', ->
    app.use           express.logger()
    app.use           express.errorHandler { 
      dumpExceptions: true, showStack: true 
    }
  app.configure 'production', ->
    app.use           express.errorHandler()
  
  # --- listening ---
  server              = app.listen process.env.PORT || port, -> 
    addr              = server.address()
    console.log       '---------------------------------------------'
    console.log       '--- app is listening on http://' + addr.address + ':' + addr.port
    console.log       '---------------------------------------------'

  # --- socket.io ---
  io                  = require('socket.io').listen(server)
  io.configure 'development', ->
    console.log       '--- socket.io is running on development environment'
    io.set            'log level', 5 
    io.set            'transports', [ 'websocket'
                                      'htmlfile'
                                      'jsonp-polling'
                                      'xhr-polling' ]
    io.set            'polling duration', 5
  io.configure 'production', ->
    console.log       '--- socket.io is running on heroku environment'
    io.enable         'browser client minifaction'
    io.enable         'browser client etag'
    io.enable         'browser client gzip'
    io.set            'log level', 1 
    io.set            'transports', [ 'xhr-polling' ]
    io.set            'polling duration', 10

  # authorizing sockets
  io.set              'authorization', (handshake, accept) ->
    if handshake.headers.cookie?
      console.log '--- handshake cookie'
      console.dir handshake.headers.cookie
      accept null, true
  # -> '/' 
  io.sockets.on 'connection', (socket) ->
    handshake         = socket.handshake
    socket.emit       'greeting', { msg: 'This message is sent from socket.io' }
  # -> '/member'
  io.of('/member').authorization (handshake, accept) ->
    accept null, true
  .on 'connection', (socket) ->
    socket.emit 'name', { first: 'John' }



