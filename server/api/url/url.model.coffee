'use strict'

mongoose = require 'mongoose'
UrlCounter = require './urlCounter.model'
config = require '../../config/environment'
Schema = mongoose.Schema

UrlSchema = new Schema
  longUrl: String
  shortenId: String
  clicked:
    type: Number
    default: 0
  createdAt:
    type: Date
    default: Date.now

UrlSchema.index { 'shortenId': 1 }, { unique: true }

Hashids = require 'hashids'
hashids = new Hashids(config.secrets.session, 6)

UrlSchema.pre 'save', (next) ->
  _this = this
  UrlCounter.findByIdAndUpdate
    _id: 'urlid'
  , $inc: { seq: 1 }
  , (err, counter) ->
    return next err  if err
    _this.shortenId = hashids.encode counter.seq
    next()

module.exports = mongoose.model 'Url', UrlSchema
