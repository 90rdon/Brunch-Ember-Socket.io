App.PostsRoute = Em.Route.extend
  model: ->
    App.Post.find()