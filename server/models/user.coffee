mongoose = require 'mongoose'

# User
UserSchema = new mongoose.Schema 
  name:
    type: String
  email:
    type: String
  password:
    type: String

UserSchema.methods.comparePassword = (password) ->
  @password is password

UserSchema.methods.getRoleId = ->
  @role or "guest"

UserSchema.statics.authenticate = (email, password, next) ->
  @findOne { email: email }, (err, user) ->
      return next(500, "Internal service error")      if err
      return next(403, "E-mail or password invalid")  if not user or not user.comparePassword(password)
      next null, user

mongoose.model 'user', UserSchema

module.exports = (connection) ->
  (connection || mongoose).model 'user'