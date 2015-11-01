'use strict'

mongoose = require 'mongoose'
UrlCounter = require './urlCounter.model'
Schema = mongoose.Schema

UrlSchema = new Schema
  shortUrl: String
  longUrl: String
  clicked:
    type: Number
    default: 0
  createdAt:
    type: Date
    default: Date.now

UrlSchema.index { 'shortUrl': 1 }, { unique: true }

UrlSchema.pre 'save', (next) ->
  _this = this
  UrlCounter.findByIdAndUpdate
    _id: 'urlid'
  , $inc: { seq: 1 }
  , (err, counter) ->
    return next err  if err
    _this.shortUrl = counter.seq.toString(36)
    next()

module.exports = mongoose.model 'Url', UrlSchema
