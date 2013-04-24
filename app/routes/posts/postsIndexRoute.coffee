App.PostsIndexRoute = Em.Route.extend
  model: ->
    App.Post.find()