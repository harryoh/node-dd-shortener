###*
Main application routes
###

'use strict'

path = require 'path'
#cache = require('express-redis-cache')({ expire: 3600 })
redis = require 'redis'
async = require 'async'

errors = require './components/errors'
ddurl = require './components/ddurl'
logger = require './components/logger'
config = require './config/environment'

if config.useRedis
  cache = redis.createClient()
  cacheStatus = false
  cache.on 'error', -> cacheStatus = false
  cache.on 'connect', ->
    console.info 'Connected redis server.'
    cacheStatus = true

module.exports = (app) ->

  app.use '/api/1.0/url', require './api/url'

  app.get /^\/([0-9a-zA-Z\+/]{6})$/, (req, res, next) ->
    async.waterfall [
      (callback) ->
        return callback null, null  if not cache or not cacheStatus

        cache.get req.params[0], (err, longUrl) ->
          callback err, longUrl

      (longUrl, callback) ->
        return callback null, longUrl  if longUrl

        ddurl.expand req.params[0], (err, result) ->
          return callback null, null  unless result
          return callback err, result.longUrl  if not cache or not cacheStatus
          cache.set req.params[0], result.longUrl, (err) ->
            callback err, result.longUrl

    ], (err, longUrl) ->
      return next err  if err
      return res.status(404).send 'Not found URL'  unless longUrl
      logger.increase req.params[0]
      res.redirect 301, longUrl

  # All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*').get errors[404]

  # All other routes should redirect to the index.html
  app.route('/*').get (req, res) ->
    res.sendFile path.resolve(app.get('appPath') + '/index.html')
