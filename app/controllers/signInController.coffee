App.SignInController = Em.ObjectController.extend
  templateName: 'signIn'
  email: null
  password: null

  signIn: ->
    socket = io.connect()

    socket.emit 'signIn', {
      data:
        email:    @get 'email'
        password: @get 'password' }
