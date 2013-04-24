App.UsersShowRoute = Auth.Route.extend
  init: ->
    @on 'authAccess', ->
      #do something here

  serialize: (model) ->
    user_id: model.get 'param'