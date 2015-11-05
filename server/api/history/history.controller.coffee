'use strict'

_ = require 'lodash'
Logger = require '../../components/logger/logger.model'
config = require '../../config/environment'

exports.list = (req, res) ->
  Logger.count (err, length) ->
    return handleError res, err  if err

    result = {total: length}
    query = Logger.find().sort({createdAt: -1}).limit(20)
    query.exec (err, history) ->
      return handleError res, err  if err
      res.status(200).json _.merge result, {history: history}

handleError = (res, err) ->
  res.status(500).send err
