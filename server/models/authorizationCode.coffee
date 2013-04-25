mongoose                = require 'mongoose'

# AuthorizationCode
AuthorizationCodeSchema = new mongoose.Schema(
  code:
    type: String

  client_id:
    type: mongoose.Schema.ObjectId
    ref: 'Client'

  user_id:
    type: mongoose.Schema.ObjectId
    ref: 'User'

  redirect_uri:
    type: String

  scope:
    type: String
)

mongoose.model 'AuthorizationCode', AuthorizationCodeSchema

module.exports = (connection) ->
  (connection || mongoose).model('AuthorizationCode')