'use strict'

validUrl = require 'valid-url'
Url = require '../../api/url/url.model'

do ->
  ddurl = {}
  ddurl.shorten = (longUrl, callback) ->
    return callback 400, new Error 'Bad Request'  unless validUrl.isUri longUrl

    # Todo:
    # Check same longurl.

    Url.create
      'longUrl': longUrl
    , (err, url) ->
      return callback 500, err  if err
      result =
        'longUrl': url.longUrl
        'shortUrl': url.shortUrl

      callback 201, null, result

  ddurl.expand = (callback)->
    callback null

  if typeof module != 'undefined' and module.exports
    module.exports = ddurl
