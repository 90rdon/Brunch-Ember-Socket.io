App.SignInController  = Em.ObjectController.extend
  templateName:       'signIn'
  username:           null
  password:           null

  signIn: ->
    Auth.signIn
      username:       @get 'username'
      password:       @get 'password'