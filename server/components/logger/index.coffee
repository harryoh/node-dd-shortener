'use strict'

ipaddr = require 'ipaddr.js'
geoip = require 'geoip-lite'
url = require 'url'

LoggerMobel = require './logger.model'
UrlModel = require '../../api/url/url.model'

do ->
  logger = (req, callback) ->

    shortenId = req.originalUrl.substr 1

    increase = (callback) ->
      UrlModel.findOneAndUpdate
        shortenId: shortenId
      , $inc: { clicked: 1 }
      , (err, result) ->
        callback? err, null

    remoteIp = ipaddr.process(
      req.headers['x-forwarded-for'] || req.connection.remoteAddress
    ).toString()

    referrer = req.headers['referer'] || ''
    log =
      shortenId: shortenId
      browser: req.useragent['browser']
      browserVersion: req.useragent['version']
      os: req.useragent['os']
      platform: req.useragent['platform']
      geoIp: geoip.lookup remoteIp
      usrerAgent: req.useragent['source']
      referrer: referrer
      referrerHost: url.parse(referrer).host
      remoteIp: remoteIp

    increase()
    LoggerMobel.create log, (err, data) ->
      callback? err, data

  if typeof module != 'undefined' and module.exports
    module.exports = logger
