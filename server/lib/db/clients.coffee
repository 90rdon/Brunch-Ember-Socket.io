clients = [
  { id: '1', name: 'linguis', clientId: 'linguis', clientSecret: 'secret' }
]

exports.find = (id, done) ->
  for client in clients
    done null, client if client.id is id
  done null, null

exports.findByClientId = (clientId, done) ->
  for client in clients
    done null, client if client.clientId is clientId
  done null, null