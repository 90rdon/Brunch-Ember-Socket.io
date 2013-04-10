App.SignInController = Em.ObjectController.extend
  email: null
  password: null

  signIn: ->
    Auth.signIn
      email:    @get 'email'
      password: @get 'password'
