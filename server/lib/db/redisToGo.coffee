express               = require 'express'
redis                 = require 'redis'
redisStore            = require('connect-redis')(express)

# --- sesion store by Redis ---
if process.env.REDISTOGO_URL?
  console.log 'using Redis remote store'
  redisToGo           = require('url').parse(process.env.REDISTOGO_URL)
  pub                 = redis.createClient(redisToGo.port, redisToGo.hostname)
  pub.auth            redisToGo.auth.split(':')[1]
  sub                 = redis.createClient(redisToGo.port, redisToGo.hostname)
  sub.auth            redisToGo.auth.split(':')[1]
  client              = redis.createClient(redisToGo.port, redisToGo.hostname)
  client.auth         redisToGo.auth.split(':')[1]
else
  console.log 'using Redis local store'
  pub                 = redis.createClient()
  sub                 = redis.createClient()
  client              = redis.createClient()

exports.sessionStore  = new redisStore {
    redis:        redis,
    redisPub:     pub,
    redisSub:     sub,
    redisClient:  client
  }