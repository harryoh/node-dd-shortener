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

exports.created = (req, res) ->
###  MONGO Query
db.getCollection('urls').aggregate([
    {
        $match: {
            createdAt: {
                $gte: ISODate("2015-11-01T00:00:00.000Z"),
                $lt: ISODate("2015-11-16T00:00:00.000Z")
            }
        }
    },
    {
        $group: {
        _id: {
            year: {$year: "$createdAt"},
            month: {$month: "$createdAt"},
            dayOfMonth: {$dayOfMonth: "$createdAt"}
        },
        count: {$sum: 1}
    }
}])
###
  res.status(200).end()

handleError = (res, err) ->
  res.status(500).send err
