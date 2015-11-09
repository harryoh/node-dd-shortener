'use strict'

express = require 'express'
controller = require './history.controller'

router = express.Router()

router.get '/', controller.list
router.get '/created', controller.created
router.get '/browser', controller.browser
router.get '/country', controller.country
router.get '/platform', controller.platform
router.get '/:shortenId', controller.detail
router.get '/:shortenId/clicks', controller.clicks

module.exports = router