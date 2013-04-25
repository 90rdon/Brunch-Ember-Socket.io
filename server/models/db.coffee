mongoose                = require 'mongoose'
config                  = require('../../config').config
host                    = config.db.host
connection              = mongoose.createConnection host, { server: { poolSize: config.db.poolSize }}

connection.on 'error', (err) ->
  console.log err 

exports.connection      = connection