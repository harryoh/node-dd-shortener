'use strict'

express = require 'express'
controller = require './history.controller'

router = express.Router()

router.get '/', controller.list
router.get '/created', controller.created
router.get '/:shortenId', controller.detail

module.exports = router