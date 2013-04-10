App.SignInView = Em.View.extend
  templateName: 'signIn'

  email:    null
  password: null

  submit: (event, view) ->
    event.preventDefault()
    event.stopPropagation()
    Auth.signIn
      email:    @get 'email'
      password: @get 'password'