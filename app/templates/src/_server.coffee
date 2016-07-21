cors               = require 'cors'
morgan             = require 'morgan'
express            = require 'express'
bodyParser         = require 'body-parser'
errorHandler       = require 'errorhandler'
OctobluRaven       = require 'octoblu-raven'
enableDestroy      = require 'server-destroy'
sendError          = require 'express-send-error'
MeshbluAuth        = require 'express-meshblu-auth'
packageVersion     = require 'express-package-version'
meshbluHealthcheck = require 'express-meshblu-healthcheck'
Router             = require './router'
<%= serviceClass %> = require './services/<%= filePrefix %>-service'
debug              = require('debug')('<%= appName %>:server')

class Server
  constructor: ({@disableLogging, @port, @meshbluConfig, @octobluRaven})->
    @octobluRaven ?= new OctobluRaven()

  address: =>
    @server.address()

  run: (callback) =>
    app = express()
    app.use @octobluRaven.express().handleErrors()
    app.use sendError()
    app.use meshbluHealthcheck()
    app.use packageVersion()
    app.use morgan 'dev', immediate: false unless @disableLogging
    app.use cors()
    app.use errorHandler()
    app.use bodyParser.urlencoded limit: '1mb', extended : true
    app.use bodyParser.json limit : '1mb'

    meshbluAuth = new MeshbluAuth @meshbluConfig
    app.use meshbluAuth.auth()
    app.use meshbluAuth.gateway()

    app.options '*', cors()

    <%= serviceInstance %> = new <%= serviceClass %>
    router = new Router {@meshbluConfig, <%= serviceInstance %>}

    router.route app

    @server = app.listen @port, callback
    enableDestroy @server

  stop: (callback) =>
    @server.close callback

  destroy: =>
    @server.destroy()

module.exports = Server
