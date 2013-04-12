sysPath               = require 'path'
http                  = require 'http'
express               = require 'express.io'
redis                 = require 'redis'
RedisStore            = require('connect-redis')(express)
auth                  = require './lib/auth/auth'
passport              = require 'passport'

exports.startExpress  = (port, base, path, callback) ->
  # --- session ---
  if process.env.REDISTOGO_URL?
    console.log '--- using Redis remote store'
    redisToGo         = require('url').parse(process.env.REDISTOGO_URL)
    pub               = redis.createClient redisToGo.port, redisToGo.hostname
    pub.auth          redisToGo.auth.split(':')[1]
    sub               = redis.createClient redisToGo.port, redisToGo.hostname
    sub.auth          redisToGo.auth.split(':')[1]
    client            = redis.createClient redisToGo.port, redisToGo.hostname
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
    key:     'express.pid',
    secret:  process.env.CLIENT_SECRET || 'mysecret'
    store:   sessionStore,
    cookie:  { maxAge: 60 * 60 * 1000 }    
  }
  # --- core ---
  app                 = express().http().io()
  app.configure ->
    app.use           express.cookieParser()
    app.use           express.bodyParser()
    app.use           express.methodOverride()
    app.use           express.session sessionConfig
    app.use           passport.initialize()
    app.use           passport.session()
    app.use           (request, response, next) ->
      response.header 'Cache-Control', 'no-cache'
      next()
    app.use           base, express.static path
    app.use           app.router
    app.all           '#{base}/*', (request, response) ->
      response.sendfile sysPath.join path, 'index.html'

  app.configure 'development', ->
    app.use           express.logger()
    app.use           express.errorHandler { 
      dumpExceptions: true, showStack: true 
    }
  app.configure 'production', ->
    app.use           express.errorHandler()
  

  # --- socket.io ---
  app.io.configure 'development', ->
    console.log           '--- socket.io is running on development environment'
    app.io.set            'log level', 5 
    app.io.set            'transports', [ 'websocket'
                                      'htmlfile'
                                      'jsonp-polling'
                                      'xhr-polling' ]
    app.io.set            'polling duration', 5
  app.io.configure 'production', ->
    console.log           '--- socket.io is running on heroku environment'
    app.io.enable         'browser client minifaction'
    app.io.enable         'browser client etag'
    app.io.enable         'browser client gzip'
    app.io.set            'log level', 1 
    app.io.set            'transports', [ 'xhr-polling' ]
    app.io.set            'polling duration', 10

  # --- routes ---
  app.io.route 'callingHome', (req) ->
    req.session.name = req.data
    req.session.loginDate = new Date().toString()
    console.log 'req session ->'
    console.dir req.session
    req.session.save ->
      req.io.emit 'get-feelings'

  app.io.route 'send-feelings', (req) ->
    req.session.name = 'Johnny'
    req.session.feelings = 'gr8!'
    req.session.save ->
      req.io.emit 'helloMessage', req.session

  app.io.route 'callingMember', (req) ->
    console.log 'member server section'
    req.session.memberMsg = 'members only ;)'
    req.session.save ->
      req.io.emit 'memberCallback', req.session

  # --- auth ---
  app.get '/redirect', (req, res) ->
    res.redirect '/'
    
  app.get '/auth/twitter', 
    passport.authenticate 'twitter', (req, res) ->
      console.log 'twitter auth'

  app.get '/auth/twitter/callback', 
    passport.authenticate('twitter', { failureRedirect: '/signIn' }),
    (req, res) ->
      res.redirect '/'

  # --- listen ---
  app.listen process.env.PORT || port, ->
    addr              = app.server.address()
    console.log       '---------------------------------------------'
    console.log       '--- app is listening on http://' + addr.address + ':' + addr.port
    console.log       '---------------------------------------------'

