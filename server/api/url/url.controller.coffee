'use strict'

_ = require 'lodash'
Url = require './url.model'
ddurl = require '../../components/ddurl'

# Get list of urls
exports.index = (req, res) ->
  Url.find (err, urls) ->
    return handleError res, err  if err
    res.status(200).json urls

# Get a single url
exports.show = (req, res) ->
  Url.findById req.params.id, (err, url) ->
    return handleError res, err  if err
    return res.status(404).send 'Not Found'  if not url
    res.json url

# shorten a new url in the DB.
exports.shorten = (req, res) ->
  hrstart = process.hrtime()
  ddurl.shorten req.body.longUrl, (statusCode, err, result) ->
    return res.status(statusCode).send err  if err
    return handleError res  unless result
    hrend = process.hrtime(hrstart)

    _.merge result,
      'shortUrl': "http://#{req.get('host')}/#{result.shortenId}"
      'executionTime':
        'sec': hrend[0]
        'ms': hrend[1]

    res.status(statusCode).json result

# expand url in the DB.
exports.expand = (req, res) ->
  return res.status(200).send('expand').end()
  Url.create req.body, (err, url) ->
    return handleError res, err  if err
    res.status(201).json url

# Updates an existing url in the DB.
exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Url.findById req.params.id, (err, url) ->
    return handleError res, err  if err
    return res.status(404).send 'Not Found'  if not url
    updated = _.merge url, req.body
    updated.save (err) ->
      return handleError res, err  if err
      res.status(200).json url

# Deletes a url from the DB.
exports.destroy = (req, res) ->
  Url.findById req.params.id, (err, url) ->
    return handleError res, err  if err
    return res.status(404).send 'Not Found'  if not url
    url.remove (err) ->
      return handleError res, err  if err
      res.status(204).send 'No Content'

handleError = (res, err) ->
  res.status(500).send err
