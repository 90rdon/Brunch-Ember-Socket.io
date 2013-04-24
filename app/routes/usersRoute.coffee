App.UsersRoute = Auth.Route.extend
  model: ->
    App.User.find()