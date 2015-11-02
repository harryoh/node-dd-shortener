'use strict'

validUrl = require 'valid-url'
url = require 'url'
UrlModel = require '../../api/url/url.model'

do ->
  ddurl = {}
  ddurl.shorten = (longUrl, callback) ->
    return callback 400, new Error 'Bad Request'  unless validUrl.isUri longUrl

    UrlModel.create
      'longUrl': longUrl
    , (err, url) ->
      return callback 500, err  if err
      result =
        'longUrl': url.longUrl
        'shortenId': url.shortenId
        'createdAt': url.createdAt

      callback 201, null, result

  ddurl.expand = (shortUrl, callback)->
    return callback 400, new Error 'Bad Request'  unless validUrl.isUri shortUrl

    parse = url.parse shortUrl, true
    shortenId = parse.path.substring(1)

    UrlModel.findOne
      'shortenId': shortenId
    , (err, url) ->
      result =
        'longUrl': url.longUrl
        'shortenId': url.shortenId
        'createdAt': url.createdAt
        'clicked': url.clicked

      callback 200, null, result

  if typeof module != 'undefined' and module.exports
    module.exports = ddurl
