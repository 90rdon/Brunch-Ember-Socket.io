mongoose                = require 'mongoose'

# Client
ClientSchema = new mongoose.Schema(
  user_id:
    type: mongoose.Schema.ObjectId
    ref: 'User'

  secret:
    type: String

  redirect_uri:
    type: String
)

mongoose.model 'Client', ClientSchema

module.exports = (connection) ->
  (connection || mongoose).model('Client')