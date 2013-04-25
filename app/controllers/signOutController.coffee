App.SignOutController = Em.ObjectController.extend
  signOut: ->
    Auth.signOut()