'use strict'

_ = require 'lodash'
Url = require './url.model'

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

# Creates a new url in the DB.
exports.create = (req, res) ->
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
