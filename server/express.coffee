sysPath               = require 'path'
http                  = require 'http'
express               = require 'express'


exports.startExpress  = (port, base, path, callback) ->
  # --- core ---
  app                 = express()
  app.configure ->
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
    console.log       '--- app listening on http://' + addr.address + ':' + addr.port

  io                  = require('socket.io').listen(server)

  # --- socket.io ---
  io.configure ->
    io.enable         'browser client minifaction'
    io.enable         'browser client etag'
    io.enable         'browser client gzip'
    io.set            'log level', 1 
    io.set            'transports', [ 'xhr-polling' ]
    io.set            'polling duration', 10

  io.sockets.on 'connection', (socket) ->
    handshake         = socket.handshake
    socket.emit       'greeting', { msg: 'This message is sent from socket.io' }

  io.of('/member').authorization (handshake, accept) ->
    accept null, true
  .on 'connection', (socket) ->
    socket.emit 'name', { first: 'John' }