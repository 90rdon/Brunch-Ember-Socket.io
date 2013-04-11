App.IndexRoute = Em.Route.extend
  setupController: (controller) ->
    socket = io.connect()

    socket.emit 'ready'

    socket.on 'error', (reason) ->
      console.error 'Unable to connect to socket.io', reason
      console.dir socket.socket

    socket.on 'get-feelings', ->
      socket.emit 'send-feelings'

    socket.on 'session', (data) ->
      message = 'Hey ' + data.name + '!\n\n'
      message += 'Server says you feel '+ data.feelings + '\n'
      message += 'I know these things because sessions work!\n\n'
      message += 'Also, you joined ' + data.loginDate + '\n'
      controller.set('msg', message)

