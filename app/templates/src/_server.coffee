cors               = require 'cors'
morgan             = require 'morgan'
express            = require 'express'
bodyParser         = require 'body-parser'
compression        = require 'compression'
OctobluRaven       = require 'octoblu-raven'
enableDestroy      = require 'server-destroy'
sendError          = require 'express-send-error'
MeshbluAuth        = require 'express-meshblu-auth'
expressVersion     = require 'express-package-version'
meshbluHealthcheck = require 'express-meshblu-healthcheck'
Router             = require './router'
<%= serviceClass %> = require './services/<%= filePrefix %>-service'
debug              = require('debug')('<%= appName %>:server')

class Server
  constructor: ({@logFn, @disableLogging, @port, @meshbluConfig, @octobluRaven})->
    throw new Error 'Missing meshbluConfig' unless @meshbluConfig?
    @octobluRaven ?= new OctobluRaven()

  address: =>
    @server.address()

  skip: (request, response) =>
    return true if @disableLogging
    return response.statusCode < 400

  run: (callback) =>
    app = express()

    app.use expressVersion { format: '{"version": "%s"}' }
    app.use meshbluHealthcheck()

    ravenExpress = @octobluRaven.express()
    app.use ravenExpress.handleErrors()
    app.use sendError({ @logFn })
    app.use cors()
    app.use bodyParser.urlencoded { limit: '1mb', extended : true }
    app.use bodyParser.json { limit : '1mb' }

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
