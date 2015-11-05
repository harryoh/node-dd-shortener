'use strict'

express = require 'express'
controller = require './history.controller'

router = express.Router()

router.get '/', controller.list

module.exports = router