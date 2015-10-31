'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

UrlSchema = new Schema
  shortUrl: String
  longUrl: String
  clicked: Number
  status: Number
  createdAt:
    type: Date
    default: Date.now

module.exports = mongoose.model 'Url', UrlSchema
