'use strict'

_ = require 'lodash'
Logger = require '../../components/logger/logger.model'
Url = require '../url/url.model'
config = require '../../config/environment'

exports.list = (req, res) ->
  Logger.count (err, length) ->
    return handleError res, err  if err

    result = {total: length}
    query = Logger.find().sort({createdAt: -1}).limit(20)
    query.exec (err, history) ->
      return handleError res, err  if err
      res.status(200).json _.merge result, {history: history}

exports.created = (req, res) ->
  Url.aggregate [
    $group:
      _id:
        year: $year: "$createdAt"
        month: $month: "$createdAt"
        dayOfMonth: $dayOfMonth: "$createdAt"
      count: $sum: 1
  ], (err, result) ->
    return handleError res, err  if err
    res.status(200).json result

exports.browser = (req, res) ->
  Logger.count (err, length) ->
    return handleError res, err  if err
    return res.status(200).end()  unless length

    Logger.aggregate [
      {
        $group:
          _id:
            browser: '$browser'
            id: '$_id'
      }, {
        $group:
          _id: '$_id.browser'
          count: $sum: 1
      }, {
        $project:
          _id: 0,
          browser: '$_id',
          count: 1
      }
    ], (err, result) ->
      return handleError res, err  if err
      data = []
      _.forEach result, (row, idx) ->
        data.push {
          'browser': row.browser
          'percentage': (row.count / length * 100).toFixed 2
        }
      res.status(200).json data

exports.country = (req, res) ->
  Logger.count (err, length) ->
    return handleError res, err  if err
    return res.status(200).end()  unless length

    Logger.aggregate [
      {
        $group:
          _id:
            country: '$geoIp.country'
            id: '$_id'
      }, {
        $group:
          _id: '$_id.country'
          count: $sum: 1
      }, {
        $project:
          _id: 0,
          country: '$_id',
          count: 1
      }
    ], (err, result) ->
      return handleError res, err  if err
      data = []
      _.forEach result, (row, idx) ->
        data.push {
          'country': row.country
          'percentage': (row.count / length * 100).toFixed 2
        }
      res.status(200).json data

exports.platform = (req, res) ->
  Logger.count (err, length) ->
    return handleError res, err  if err
    return res.status(200).end()  unless length

    Logger.aggregate [
      {
        $group:
          _id:
            platform: '$platform'
            id: '$_id'
      }, {
        $group:
          _id: '$_id.platform'
          count: $sum: 1
      }, {
        $project:
          _id: 0,
          platform: '$_id',
          count: 1
      }
    ], (err, result) ->
      return handleError res, err  if err
      data = []
      _.forEach result, (row, idx) ->
        data.push {
          'platform': row.platform
          'percentage': (row.count / length * 100).toFixed 2
        }
      res.status(200).json data

exports.detail = (req, res) ->
  Logger.count (err, length) ->
    return handleError res, err  if err

    result = {total: length}
    query = Logger.find
      shortenId: req.params.shortenId
    .sort({createdAt: -1}).limit(20)
    query.exec (err, history) ->
      return handleError res, err  if err
      res.status(200).json _.merge result, {history: history}

exports.clicks = (req, res) ->
  Logger.aggregate [
    { $match: shortenId: req.params.shortenId }
    { $group:
      _id:
        year: $year: "$createdAt"
        month: $month: "$createdAt"
        dayOfMonth: $dayOfMonth: "$createdAt"
      count: $sum: 1
    }
  ], (err, result) ->
    return handleError res, err  if err
    res.status(200).json result

exports.detail_browser = (req, res) ->
  Logger.count {shortenId: req.params.shortenId}, (err, length) ->
    return handleError res, err  if err
    return res.status(200).end()  unless length

    Logger.aggregate [
      {
        $match: shortenId: req.params.shortenId
      }, {
        $group:
          _id:
            browser: '$browser'
            id: '$_id'
      }, {
        $group:
          _id: '$_id.browser'
          count: $sum: 1
      }, {
        $project:
          _id: 0,
          browser: '$_id',
          count: 1
      }
    ], (err, result) ->
      return handleError res, err  if err
      data = []
      _.forEach result, (row, idx) ->
        data.push {
          'browser': row.browser
          'percentage': (row.count / length * 100).toFixed 2
        }
      res.status(200).json data

exports.detail_country = (req, res) ->
  Logger.count {shortenId: req.params.shortenId}, (err, length) ->
    return handleError res, err  if err
    return res.status(200).end()  unless length

    Logger.aggregate [
      {
        $match: shortenId: req.params.shortenId
      }, {
        $group:
          _id:
            country: '$geoIp.country'
            id: '$_id'
      }, {
        $group:
          _id: '$_id.country'
          count: $sum: 1
      }, {
        $project:
          _id: 0,
          country: '$_id',
          count: 1
      }
    ], (err, result) ->
      return handleError res, err  if err
      data = []
      _.forEach result, (row, idx) ->
        data.push {
          'country': row.country
          'percentage': (row.count / length * 100).toFixed 2
        }
      res.status(200).json data

exports.detail_platform = (req, res) ->
  Logger.count { shortenId: req.params.shortenId }, (err, length) ->
    return handleError res, err  if err
    return res.status(200).end()  unless length

    Logger.aggregate [
      {
        $match: shortenId: req.params.shortenId
      }, {
        $group:
          _id:
            platform: '$platform'
            id: '$_id'
      }, {
        $group:
          _id: '$_id.platform'
          count: $sum: 1
      }, {
        $project:
          _id: 0,
          platform: '$_id',
          count: 1
      }
    ], (err, result) ->
      return handleError res, err  if err
      data = []
      _.forEach result, (row, idx) ->
        data.push {
          'platform': row.platform
          'percentage': (row.count / length * 100).toFixed 2
        }
      res.status(200).json data

exports.detail_referrer = (req, res) ->
  Logger.count { shortenId: req.params.shortenId }, (err, length) ->
    return handleError res, err  if err
    return res.status(200).end()  unless length

    Logger.aggregate [
      {
        $match: shortenId: req.params.shortenId
      }, {
        $group:
          _id:
            referrerHost: '$referrerHost'
            id: '$_id'
      }, {
        $group:
          _id: '$_id.referrerHost'
          count: $sum: 1
      }, {
        $project:
          _id: 0,
          referrerHost: '$_id',
          count: 1
      }
    ], (err, result) ->
      return handleError res, err  if err
      data = []
      _.forEach result, (row, idx) ->
        data.push {
          'referrerHost': row.referrerHost
          'percentage': (row.count / length * 100).toFixed 2
        }
      res.status(200).json data

exports.detail_remoteip = (req, res) ->
  Logger.count { shortenId: req.params.shortenId }, (err, length) ->
    return handleError res, err  if err
    return res.status(200).end()  unless length

    Logger.aggregate [
      {
        $match: shortenId: req.params.shortenId
      }, {
        $group:
          _id:
            remoteIp: '$remoteIp'
            id: '$_id'
      }, {
        $group:
          _id: '$_id.remoteIp'
          count: $sum: 1
      }, {
        $project:
          _id: 0,
          remoteIp: '$_id',
          count: 1
      }
    ], (err, result) ->
      return handleError res, err  if err
      data = []
      _.forEach result, (row, idx) ->
        data.push {
          'remoteIp': row.remoteIp
          'percentage': (row.count / length * 100).toFixed 2
        }
      res.status(200).json data

handleError = (res, err) ->
  res.status(500).send err

