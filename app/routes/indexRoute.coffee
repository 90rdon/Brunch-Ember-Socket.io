App.IndexRoute = Em.Route.extend
  setupController: (controller) ->
    socket = io.connect()

    socket.emit 'callingHome'

    socket.on 'error', (reason) ->
      console.error 'Unable to connect to socket.io', reason
      console.dir socket.socket

    socket.on 'get-feelings', ->
      socket.emit 'send-feelings'

    socket.on 'helloMessage', (data) ->
      message = 'Hey ' + data.name + '!\n\n'
      message += 'I heard that you are feeling '+ data.feelings + '\n'
      controller.set('msg', message)

