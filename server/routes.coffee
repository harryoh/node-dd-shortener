###*
Main application routes
###

'use strict'

errors = require './components/errors'
path = require 'path'
ddurl = require './components/ddurl'

module.exports = (app) ->

  # Insert routes below
  app.use '/api/1.0/url', require './api/url'
  #app.use '/api/users', require './api/user'
  #app.use '/auth', require './auth'

  app.get /^\/([0-9a-zA-Z\+/]{6})$/, (req, res, next) ->
    ddurl.expand req.params[0], (err, result) ->
      return next(err)  if err
      return res.status(404).send 'Not found URL'  unless result

      res.redirect 301, result.longUrl

  # All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*').get errors[404]

  # All other routes should redirect to the index.html
  app.route('/*').get (req, res) ->
    res.sendFile path.resolve(app.get('appPath') + '/index.html')
