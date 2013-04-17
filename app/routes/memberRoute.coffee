App.MemberRoute = Em.Route.extend
  route: '/member',
  setupController: (controller) ->
    socket = io.connect('/member')

    socket.on 'connect', ->
      socket.on 'error', (reason) ->
        console.error 'Unable to connect to socket.io', reason
        console.dir socket.socket

      socket.on 'membermsg', (data) ->
        controller.set('msg', data.info)