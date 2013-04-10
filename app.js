require('coffee-script');
var config = require('./config');
var server = require('./server/server.coffee');
var port = 3333;
var callback = null;

server.startServer(port, __dirname + '/public', callback);