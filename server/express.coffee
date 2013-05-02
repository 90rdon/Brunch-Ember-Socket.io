sysPath                 = require 'path'
http                    = require 'http'
express                 = require 'express'
redis                   = require 'redis'
RedisStore              = require('connect-redis')(express)
auth                    = require './lib/auth/strategies'
passport                = require 'passport'
# socket                  = require './lib/sockets/socket.io'
oauth2                  = require './lib/auth/oauth2-server'
routes                  = require './routes'

# --- session ---
if process.env.REDISTOGO_URL?
  console.log '--- using Redis remote store'
  redisToGo             = require('url').parse(process.env.REDISTOGO_URL)
  pub                   = redis.createClient redisToGo.port, redisToGo.hostname
  pub.auth              redisToGo.auth.split(':')[1]
  sub                   = redis.createClient redisToGo.port, redisToGo.hostname
  sub.auth              redisToGo.auth.split(':')[1]
  client                = redis.createClient redisToGo.port, redisToGo.hostname
  client.auth           redisToGo.auth.split(':')[1]
else
  console.log '--- using Redis local store'
  pub                   = redis.createClient()
  sub                   = redis.createClient()
  client                = redis.createClient()
sessionStore            = new RedisStore {
  pub:        pub,
  sub:        sub,
  client:     client
}
sessionConfig           = {
  key:        'express.pid',
  secret:     process.env.CLIENT_SECRET || 'mysecret'
  store:      sessionStore,
  cookie:     { maxAge: 60 * 60 * 1000 }    
}
# --- core ---
app                     = express()

app.configure 'development', ->
  app.use               express.logger()
  app.use               express.errorHandler { 
    dumpExceptions:     true, showStack: true 
  }
app.configure 'production', ->
  app.use               express.errorHandler()

app.configure ->
  app.use               express.cookieParser()
  app.use               express.bodyParser()
  app.use               express.methodOverride()
  app.use               express.session sessionConfig
  app.use               passport.initialize()
  app.use               passport.session()

# --- routes ---
app.post      '/api/login', 
  routes.auth.login

app.post      '/api/logout',
  routes.auth.logout

app.get       '/api/info',
  routes.auth.info()

app.get       '/api/authorize/',
  oauth2.authorization

app.post      '/api/authorize/decision',
  oauth2.decision

app.post      '/api/token',
  oauth2.token

app.get       '/api/twitter', 
  passport.authenticate 'twitter', 
  (req, res) ->
    console.log 'twitter auth'

app.get       '/api/twitter/callback', 
  passport.authenticate('twitter', { failureRedirect: '#/signIn' }),
  (req, res) ->
    res.redirect '/'


exports.startExpress    = (port, base, path, callback) ->
  app.configure ->
    app.use             (request, response, next) ->
      response.header   'Cache-Control', 'no-cache'
      next()
    app.use             base, express.static path
    app.use             app.router
    app.all             '#{base}/*', (request, response) ->
      response.sendfile sysPath.join path, 'index.html'

  # --- listen ---
  server                = http.createServer(app)
  # socket.startSocket    server, sessionConfig

  server.listen process.env.PORT || port, ->
    addr                = server.address()
    console.log         '---------------------------------------------'
    console.log         '--- app is listening on http://' + addr.address + ':' + addr.port
    console.log         '---------------------------------------------'

  return

