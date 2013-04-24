window.App = require 'app'

#//////////////////////////////////
#// Config
#//////////////////////////////////

require 'config/authConfig'

#//////////////////////////////////
#// Templates
#//////////////////////////////////

require 'templates/application'
require 'templates/index'
require 'templates/about'
require 'templates/_well'
require 'templates/member'
# require 'templates/signIn'
# require 'templates/signOut'

#//////////////////////////////////
#// Models
#//////////////////////////////////

require 'models/post'
require 'models/user'

#/////////////////////////////////
#// Controllers
#/////////////////////////////////

require 'controllers/applicationController'
require 'controllers/postsController'
require 'controllers/usersController'
require 'controllers/users/usersIndexController'
require 'controllers/users/usersShowController'
require 'controllers/posts/postsIndexController'
require 'controllers/posts/postsShowController'

#/////////////////////////////////
#// Views
#/////////////////////////////////

require 'views/authView'
require 'views/auth/sign-in'
require 'views/auth/sign-out'

#/////////////////////////////////
#// Routes
#/////////////////////////////////

require 'routes/applicationRoute'
require 'routes/indexRoute'
require 'routes/memberRoute'
# require 'routes/signInRoute'
# require 'routes/signOutRoute'
require 'routes/postsRoute'
require 'routes/usersRoute'
require 'routes/users/usersIndexRoute'
require 'routes/users/usersShowRoute'
require 'routes/posts/postsIndexRoute'
require 'routes/posts/postsShowRoute'

#/////////////////////////////////
#// Store
#/////////////////////////////////

App.Store = DS.Store.extend
  revision: 12
  adapter:  Auth.RESTAdapter.create()
  url:      '/api'

#/////////////////////////////////
#// Router
#/////////////////////////////////

App.Router.reopen
  location:   'history'

App.Router.map ->
  @route      'about'
  @route      'index',      path: '/'
  @route      'member'
  @resource   'posts', ->
    @route    'show',       { path: '/:post_id' }
  @resource   'users', ->
    @route    'show',       { path: '/:user_id' }
