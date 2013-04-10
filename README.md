# Introduction
This is a documentation of my personal apporoach to building a functional node.js with heroku as a host provider. 

# Libraries
[Brunch](bunch.io) - Application assembler for HTML5 apps.

[CoffeeScript](http://coffeescript.org/) - JavaScript annotations.

[Express](http://expressjs.com) - Web app framework.

[Socket.Io](http://socket.io) - WebSocket for realtime apps.

[Passport](http://passportjs.org) - Authentication for Node.js.

# Getting Started

* Get [brunch.io](brunch.io). instruction [here](http://blog.stevenlu.com/2012/05/04/brunchio-on-mac-osx/)
* Create a brunch project. 

		$-> brunch new <name of your project> --skeleton git://github.com/octapus/Brunch-Ember-Socket.io

* Get dependencies for the project
		
		$-> npm install
	It will build itself after the install.
	
* Run the server and watch the project

		$-> brunch watch -server
		
* You can then check out your browser 
		
		 http://localhost:3333
	You will get something like this in return on the command prompt
		
		info  - socket.io started
		--- app listening on http://0.0.0.0:3333
		10 Apr 01:05:22 - info: compiled in 355ms
		   debug - served static content /socket.io.js
		   debug - client authorized
		   info  - handshake authorized xuGzgI4UBwYG-hzPVX18
		   debug - setting request GET /socket.io/1/websocket/xuGzgI4UBwYG-hzPVX18
		   debug - set heartbeat interval for client xuGzgI4UBwYG-hzPVX18
		   debug - client authorized for
		   debug - websocket writing 1::
	This means you have a socket.io connection with your client.
	
*	You can deploy this to heroku by this point. Make sure you have heroku installed or follow the instructions [here](https://toolbelt.heroku.com/).

	The best thing is to test your app locally before deploying to heroku:	
	
		$-> brunch build
		
		$-> foreman start


*	By this point, you should have a remote heroku repository added to your git. Commit your changes to your git master. Then push this to your heroku remote repository.

		$-> git push heroku master

*	Open your app up 

		$-> heroku open
		
* 	[Next](https://github.com/octapus/Brunch-Ember-Socket.io/wiki/Building-Node-with-Express.js) we will configure our Express app