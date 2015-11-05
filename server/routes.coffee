###*
Main application routes
###

'use strict'

path = require 'path'
request = require 'request'
redis = require 'redis'
async = require 'async'
lru = require 'lru-cache'

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

if config.useLru
  lruCache = lru { max: 100, maxAge: 1000 * 60 * 60 }

module.exports = (app) ->

  app.use '/api/1.0/url', require './api/url'

  app.get /^\/([0-9a-zA-Z\+/]{6})$/, (req, res, next) ->
    async.waterfall [
      (callback) ->
        return callback null, null  unless lruCache
        callback null, lruCache.get req.params[0] || null

      (longUrl, callback) ->
        if longUrl or not cache or not cacheStatus
          return callback null, longUrl

        cache.get req.params[0], (err, longUrl) ->
          lruCache.set req.params[0], longUrl  if lruCache
          callback err, longUrl

      (longUrl, callback) ->
        return callback null, longUrl  if longUrl

        ddurl.expand req.params[0], (err, result) ->
          return callback null, null  unless result

          lruCache.set req.params[0], result.longUrl  if lruCache
          if cache and cacheStatus
            cache.set req.params[0], result.longUrl, (err) ->
              callback err, result.longUrl
          else
            return callback err, result.longUrl

    ], (err, longUrl) ->
      return next err  if err
      return res.status(404).send 'Not found URL'  unless longUrl
      logger req
      res.redirect 301, longUrl

  # All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*').get errors[404]

  # All other routes should redirect to the index.html
  app.route('/*').get (req, res) ->
    res.sendFile path.resolve(app.get('appPath') + '/index.html')
