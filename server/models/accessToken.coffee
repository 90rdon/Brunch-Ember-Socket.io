mongoose                = require 'mongoose'

# AccessToken
AccessTokenSchema = new mongoose.Schema(
  oauth_token:
    type: String

  user_id:
    type: mongoose.Schema.ObjectId
    ref: 'User'

  client_id:
    type: mongoose.Schema.ObjectId
    ref: 'Client'

  expires:
    type: Number

  scope:
    type: String
)

mongoose.model 'AccessToken', AccessTokenSchema

module.exports = (connection) ->
  (connection || mongoose).model('AccessToken')