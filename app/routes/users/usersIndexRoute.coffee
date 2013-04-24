App.UsersIndexRoute = Auth.Route.extend
  init: ->
    @on 'authAccess', ->
      # do something here

  model: ->
    App.User.find()