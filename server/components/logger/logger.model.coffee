'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

LoggerSchema = new Schema
  shortenId: String
  browser: String
  browserVersion: String
  os: String
  platform: String
  geoIp: Schema.Types.Mixed
  userAgent: String
  referrer: String
  referrerHost: String
  remoteIp: String

  createdAt:
    type: Date
    default: Date.now

LoggerSchema.index { 'shortenId': 1 }
LoggerSchema.index { 'createdAt': -1 }

module.exports = mongoose.model 'Logger', LoggerSchema
