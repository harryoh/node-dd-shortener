'use strict'

UrlModel = require '../../api/url/url.model'

do ->
  logger = {}
  logger.increase = (shortenId, callback) ->
    UrlModel.findOneAndUpdate
      shortenId: shortenId
    , $inc: { clicked: 1 }
    , (err, result) ->
      callback? err, null

  if typeof module != 'undefined' and module.exports
    module.exports = logger
