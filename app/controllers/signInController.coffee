App.SignInController  = Em.ObjectController.extend Auth.SignInController,
  templateName:       'signIn'
  username:           null
  password:           null

  signIn: ->
    @registerRedirect()
    Auth.signIn
      username:       @get 'username'
      password:       @get 'password'