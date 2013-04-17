users = [
  { id: 1, username: 'bob', password: 'secret', name: 'Bob Smith', email: 'bob@example.com' },
  { id: 2, username: 'joe', password: 'password', name: 'Joe Davis', email: 'joe@example.com' }
]

exports.find = (id, done) ->
  for user in users 
    return done null, user if user.id is id
    done new Error('User ' + id + ' does not exist'), null

exports.findByUsername = (username, done) ->
  for user in users
    return done null, user if user.username is username
    done null, null