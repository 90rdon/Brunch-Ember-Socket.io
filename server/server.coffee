config              = require('../config').config
cluster             = require 'cluster'
numCPUs             = require('os').cpus().length
worker              = require('./express')

# Took the proxy server out while using heroku
# heroku only allows the app to run on the assigned process.env.PORT
# heroku redirects 80 to express running on process.env.PORT by default
exports.startServer = (port, publicPath, callback) ->
  if process.env.NODE_ENV is 'production' and cluster.isMaster
    num = process.env.CLUSTER_MAX || numCPUs    # -- manually controlling this (for now) because we are limited by RedisToGo nano's connection limit
    console.log     'Started clusters -> ' + num + ' out of ' + numCPUs + ' cpus'
    
    i = 0
    while i < num
      cluster.fork()     
      i++   

    cluster.on      'fork', (worker) ->
      console.log 'forked worker ->' + worker.process.pid
    cluster.on      'listening', (worker, address) ->
      console.log 'worker -> ' + worker.process.pid + ' is now connected to ' + address.address + ':' + address.port  
    cluster.on      'exit', (worker, code, signal) ->
      console.log 'worker -> ' + worker.process.pid + ' terminated.'

  else
    processPort         = process.env.PORT || port
    worker.startExpress processPort, config.server.base, publicPath, callback