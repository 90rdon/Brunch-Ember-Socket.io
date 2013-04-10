sysPath               = require 'path'
http                  = require 'http'
express               = require 'express'

exports.startExpress  = (port, base, path, callback) ->
  # --- core ---
  app                 = express()

  app.configure ->
    app.use       base, express.static path
    app.all       '#{base}/*', (request, response) ->
      response.sendfile sysPath.join path, 'index.html'


  # --- listening ---
  server              = app.listen process.env.PORT || port, -> 
    addr = server.address()
    console.log '--- app listening on http://' + addr.address + ':' + addr.port

  io                  = require('socket.io').listen(server)

  # --- socket.io ---
  io.configure 'production', ->
    io.set    'transports', ['xhr-polling']
    io.set    'polling duration', 20

  io.sockets.on 'connection', (socket) ->
    socket.on   'user message', (msg) ->
      socket.broadcast.emit 'user message', socket.nickname, msg

    socket.on 'nickname', (nick, fn) ->
      if nicknames[nick] 
        fn(true)
      else
        fn(false)
        nicknames[nick] = socket.nickname = nick
        socket.broadcast.emit 'announcement', nick + ' connected.'
        io.sockets.emit 'nicknames', nicknames

    socket.on 'disconnect', ->
      if socket.nickname? 
        delete nicknames[socket.nickname]
        socket.broadcast.emit 'announcement', socket.nickname + ' disconnected.'
        socket.broadcast.emit 'nicknames', nicknames