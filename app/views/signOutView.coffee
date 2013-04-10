App.SignOutView = Em.View.extend
  templateName: 'signOut'

  submit: (event, view) ->
    event.preventDefault()
    event.stopPropagation()
    Auth.signOut()