authRoutes              = exports ? this
models                  = require '../models'
passport                = require 'passport'

# exports.ensureLoggedIn          = ->
#   (req, res, next) ->
#     return res.redirect '/login'                        if not req.session.user? or not req.session.user.id?
#     next()

# exports.login           = (req, res, next) ->
#   return res.json(error: 'You r logged in!')  if req.session.user?
#   return res.status(400).json(error: 'Bad request')     if not req.body? or not req.body.email? or not req.body.password?
  
#   models.user.authenticate req.body.email, req.body.password, (err, user) ->
#     return res.status(err).json(error: user)            if 'number' is typeof err
#     return res.status(400).json(error: err)             if not user? or err
#     req.session.user = 
#       id: user._id
#       name: user.name
#       email: user.email
#     return res.json req.session.user

exports.oauth_login     = (req, res, next) ->
  return res.status(400).json(error: 'Param missing')   if not req.query? or not req.query.email? or not req.query.password? or not req.query.client_id? or not req.query.redirect_uri? or not req.query.response_type? 
  return res.redirect(req.query.redirect_uri)           if req.session.user?
  
  models.user.authenticate req.query.email, req.query.password, (err, user) ->
    return res.status(err).json(error: user)            if 'number' is typeof err
    return res.status(400).json(error: err)             if not user? or err
    req.session.user = 
      id: user._id
      name: user.name
      email: user.email
    next()

exports.logout          = (req, res) ->
  req.session.destroy (err) ->
    return res.status(500).json(error: 'Internal service error.')  if err
    delete req.session

    res.json success: 'Good bye!'

exports.info           = -> [
  passport.authenticate('bearer', session: false), (req, res) ->
    res.json
      user_id:  req.user.id
      name:     req.user.name
      scope:    req.authInfo.scope
]