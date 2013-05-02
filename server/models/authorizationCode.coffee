mongoose = require 'mongoose'

# AuthorizationCode
AuthorizationCodeSchema = new mongoose.Schema
  code:
    type: String
  client_id:
    type: mongoose.Schema.ObjectId
    ref:  'client'
  user_id:
    type: mongoose.Schema.ObjectId
    ref:  'user'
  redirect_uri:
    type: String
  scope:
    type: String

mongoose.model 'authorizationCode', AuthorizationCodeSchema

module.exports = (connection) ->
  (connection || mongoose).model('authorizationCode')