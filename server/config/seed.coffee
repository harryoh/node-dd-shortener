###*
Populate DB with sample data on server start
to disable, edit config/environment/index.js, and set `seedDB: false`
###

'use strict'

User = require '../api/user/user.model'
UrlCounter = require '../api/url/urlCounter.model'

User.count (err, length) ->
  if not length
    User.find({}).remove ->
      User.create
        provider: 'local'
        name: 'Test User'
        email: 'test@test.com'
        password: 'test'
      ,
        provider: 'local'
        role: 'admin'
        name: 'Admin'
        email: 'admin@admin.com'
        password: 'admin'
      , ->
        console.log 'finished populating users'

UrlCounter.count (err, length) ->
  if not length
    UrlCounter.create
      _id: "urlid"
    , ->
      console.log 'init url counter'