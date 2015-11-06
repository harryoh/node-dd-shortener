'use strict'

_ = require 'lodash'
url = require 'url'
UrlModel = require './url.model'
ddurl = require '../../components/ddurl'

_checkUrl = (url) ->
  regexp = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi
  return regexp.test url

# Get list of urls
exports.list = (req, res) ->
  UrlModel.count (err, length) ->
    return handleError res, err  if err

    result = {total: length}
    query = UrlModel.find().sort({createdAt: -1}).limit(20)
    query.exec (err, urls) ->
      return handleError res, err  if err
      res.status(200).json _.merge result, {urls: urls}

# Get a single url
exports.show = (req, res) ->
  UrlModel.findById req.params.id, (err, url) ->
    return handleError res, err  if err
    return res.status(404).send 'Not Found'  if not url
    res.json url

# shorten a new url in the DB.
exports.shorten = (req, res) ->
  parse = url.parse req.body.longUrl
  if not parse.protocol
    longUrl = "http://#{parse.href}"
  else
    longUrl = req.body.longUrl

  if not _checkUrl longUrl
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
  if not _checkUrl.isUri req.query.shortUrl
    return res.status(400).send 'Bad Request'

  parse = url.parse req.query.shortUrl, true
  shortenId = parse.path.substr 1

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
