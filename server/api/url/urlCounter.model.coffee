'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

UrlCounterSchema = new Schema
  _id:
    type: String
    required: true
  seq:
    type: Number
    default: 0

module.exports = mongoose.model 'UrlCounter', UrlCounterSchema
