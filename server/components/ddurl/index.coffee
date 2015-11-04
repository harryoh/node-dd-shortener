'use strict'

UrlModel = require '../../api/url/url.model'

do ->
  ddurl = {}
  ddurl.shorten = (longUrl, callback) ->

    UrlModel.create
      'longUrl': longUrl
    , (err, url) ->
      return callback err  if err
      result =
        'longUrl': url.longUrl
        'shortenId': url.shortenId
        'createdAt': url.createdAt

      callback null, result

  ddurl.expand = (shortenId, callback)->
    UrlModel.findOne
      'shortenId': shortenId
    , (err, url) ->
      result =
        'longUrl': url.longUrl
        'shortenId': url.shortenId
        'createdAt': url.createdAt
        'clicked': url.clicked

      callback null, result

  if typeof module != 'undefined' and module.exports
    module.exports = ddurl
