App.IndexRoute = Em.Route.extend
  setupController: (controller) ->
    socket = io.connect()

    socket.on 'connect', ->
      socket.on 'error', (reason) ->
        console.error 'Unable to connect to socket.io', reason
        console.dir socket.socket

      socket.on 'message', (msg) ->
        console.dir msg
        message = 'Hey ' + msg
        controller.set('msg', message)