'use strict'

express = require 'express'
controller = require './url.controller'
auth = require '../../auth/auth.service'

router = express.Router()

router.post '/', controller.shorten
router.get '/:id', controller.show
router.get '/', controller.expand

#router.get '/', auth.hasRole('admin'), controller.index
router.put '/:id', auth.hasRole('admin'), controller.update
router.patch '/:id', auth.hasRole('admin'), controller.update
router.delete '/:id', auth.hasRole('admin'), controller.destroy

module.exports = router
