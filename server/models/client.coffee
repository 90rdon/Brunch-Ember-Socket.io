mongoose = require 'mongoose'

# Client
ClientSchema = new mongoose.Schema
  user_id:
    type: mongoose.Schema.ObjectId
    ref: 'user'
  secret:
    type: String
  redirect_uri:
    type: String

mongoose.model 'client', ClientSchema

module.exports = (connection) ->
  (connection || mongoose).model('client')