users = [
  { id: 1, username: 'bob', password: 'secret', name: 'Bob Smith', email: 'bob@example.com' },
  { id: 2, username: 'joe', password: 'password', name: 'Joe Davis', email: 'joe@example.com' }
]

exports.find = (id, done) ->
  # idx = id - 1
  # if users[idx]
  #   fn null, users[idx]
  # else
  #   fn new Error('User ' + id + ' does not exist')
  for user in users 
    done null, user if user.id is id
    done null, null

exports.findByUsername = (username, done) ->
  # i = 0
  # len = users.length

  # while i < len
  #   user = users[i]
  #   return fn(null, user)  if user.username is username
  #   i++
  # fn null, null
  for user in users
    done null, user if user.username is username
    done null, null