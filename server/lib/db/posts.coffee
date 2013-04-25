posts = [
  { title: 'post 1' },
  { title: 'post 2' },
  { title: 'post 3' },
  { title: 'post 4' },
  { title: 'post 5' }  
]

exports.find = (done) ->
  done null, posts

exports.findByTitle = (title, done) ->
  for post in posts
    return done null, post if post.title is title
    done null, null