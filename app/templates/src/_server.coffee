cors               = require 'cors'
morgan             = require 'morgan'
express            = require 'express'
bodyParser         = require 'body-parser'
errorHandler       = require 'errorhandler'
enableDestroy      = require 'server-destroy'
MeshbluAuth        = require 'express-meshblu-auth'
meshbluHealthcheck = require 'express-meshblu-healthcheck'
packageVersion     = require 'express-package-version'
sendError          = require 'express-send-error'
Router             = require './router'
<%= serviceClass %> = require './services/<%= filePrefix %>-service'
debug              = require('debug')('<%= appName %>:server')

class Server
  constructor: ({@disableLogging, @port, @meshbluConfig})->

  address: =>
    @server.address()

  run: (callback) =>
    app = express()
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
