App.SignOutController = Em.ObjectController.extend Auth.SignOutController,
  signOut: ->
    @registerRedirect()
    Auth.signOut()