'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

require('mongoose-long')(mongoose)

UrlCounterSchema = new Schema
  _id:
    type: String
    required: true
  seq:
    type: Schema.Types.Long
    default: 61000000

module.exports = mongoose.model 'UrlCounter', UrlCounterSchema
