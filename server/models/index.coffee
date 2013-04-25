db                            = require('./db').connection

exports.user                  = require('./user')(db)
exports.client                = require('./client')(db)
exports.accessToken           = require('./accessToken')(db)
exports.authorizationCode     = require('./authorizationCode')(db)