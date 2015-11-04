'use strict'

_ = require 'lodash'
UrlModel = require '../../api/url/url.model'
url = require 'url'
validUrl = require 'valid-url'
ddurl = require '../../components/ddurl'

# Get list of urls
exports.index = (req, res) ->
  UrlModel.find (err, urls) ->
    return handleError res, err  if err
    res.status(200).json urls

# Get a single url
exports.show = (req, res) ->
  UrlModel.findById req.params.id, (err, url) ->
    return handleError res, err  if err
    return res.status(404).send 'Not Found'  if not url
    res.json url

# shorten a new url in the DB.
exports.shorten = (req, res) ->
  ###
  parse = url.parse req.body.longUrl
  if not parse.protocol
    longUrl = "http://#{parse.href}"
  else
    longUrl = req.body.longUrl
  ###
  longUrl = req.body.longUrl

  if not validUrl.isUri longUrl
    return res.status(400).send 'Bad Request'

  hrstart = process.hrtime()
  ddurl.shorten longUrl, (err, result) ->
    return handleError res, err  if err
    return res.status(404).send 'Not found URL'  unless result

    hrend = process.hrtime(hrstart)
    _.merge result,
      'shortUrl': "http://#{req.get('host')}/#{result.shortenId}"
      'executionTime':
        'sec': hrend[0]
        'ms': hrend[1]

    delete result.shortenId
    res.status(201).json result

# expand url in the DB.
exports.expand = (req, res) ->
  if not validUrl.isUri req.query.shortUrl
    return res.status(400).send 'Bad Request'

  parse = url.parse req.query.shortUrl, true
  shortenId = parse.path.substring(1)

  hrstart = process.hrtime()
  ddurl.expand shortenId, (err, result) ->
    return handleError res, err  if err
    return res.status(404).send 'Not found URL'  unless result

    hrend = process.hrtime(hrstart)
    _.merge result,
      'executionTime':
        'sec': hrend[0]
        'ms': hrend[1]

    res.status(200).json result

# Updates an existing url in the DB.
exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  UrlModel.findById req.params.id, (err, url) ->
    return handleError res, err  if err
    return res.status(404).send 'Not Found'  if not url
    updated = _.merge url, req.body
    updated.save (err) ->
      return handleError res, err  if err
      res.status(200).json url

# Deletes a url from the DB.
exports.destroy = (req, res) ->
  UrlModel.findById req.params.id, (err, url) ->
    return handleError res, err  if err
    return res.status(404).send 'Not Found'  if not url
    url.remove (err) ->
      return handleError res, err  if err
      res.status(204).send 'No Content'

handleError = (res, err) ->
  res.status(500).send err
