App.MemberRoute = Em.Route.extend
  route: '/member',
  setupController: (controller) ->
    socket = io.connect()

    socket.emit 'callingMember'

    socket.on 'memberCallback', (data) ->
      controller.set('msg', data.memberMsg)