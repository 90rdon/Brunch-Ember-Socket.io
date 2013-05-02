clients = [
  id: '1'
  user_id: '1'
  name: 'linguis'
  clientId: 'linguis'
  secret: 'secret'
  redirect_uri: ''
]

exports.find = (id, done) ->
  for client in clients
    done null, client if client.id is id
  done null, null

exports.findByUserName = (username, done) ->
  for client in clients
    done null, client if client.username is username
  done null, null

exports.findByClientId = (clientId, done) ->
  for client in clients
    done null, client if client.clientId is clientId
  done null, null