
'use strict'

async = require 'async'
Url = require '../api/url/url.model'

Url.count (err, length) ->

  if not length
    console.log '>>>>> Start Input URL dummy data'
    async.eachSeries [0..100000], (i, callback) ->
      Url.create
        'longUrl': "http://5004.pe.kr/#{i}"
      , (err, url) ->
        if err
          console.error 'Failed to insert url default data'
          return callback err

        callback null

    , (err) ->
      return console.error err  if err
      console.log '<<<<< Complete dummy url data'