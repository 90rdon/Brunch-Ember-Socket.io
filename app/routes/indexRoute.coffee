App.IndexRoute = Em.Route.extend
  setupController: (controller) ->
    socket = io.connect()

    socket.on 'error', (reason) ->
      console.error 'Unable to connect to socket.io', reason
      console.dir socket.socket

    socket.on 'greeting', (data) ->
      controller.set('msg', data.msg)