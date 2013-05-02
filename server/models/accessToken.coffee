mongoose = require 'mongoose'

# AccessToken
AccessTokenSchema = new mongoose.Schema
  oauth_token:
    type: String
  user_id:
    type: mongoose.Schema.ObjectId
    ref:  'user'
  client_id:
    type: mongoose.Schema.ObjectId
    ref:  'client'
  expires:
    type: Number
  scope:
    type: String

mongoose.model 'accessToken', AccessTokenSchema

module.exports = (connection) ->
  (connection || mongoose).model('accessToken')