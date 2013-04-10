App.SignOutControllerController = Em.ObjectController.extend
  signOut: ->
    Auth.signOut()