App.MemberRoute = Em.Route.extend
  route: '/member',
  setupController: (controller) ->
    socket = io.connect()

    socket.on 'session', (data) ->
      message = 'Hey ' + data.name + '!\n\n'
      message += 'Server says you feel '+ data.feelings + '\n'
      message += 'You are in the members only section!\n\n'
      message += 'Also, you joined ' + data.loginDate + '\n'
      controller.set('msg', message)