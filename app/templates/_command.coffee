_              = require 'lodash'
envalid        = require 'envalid'
MeshbluConfig  = require 'meshblu-config'
SigtermHandler = require 'sigterm-handler'
Server         = require './src/server'

envConfig =
  PORT: envalid.num({ port: 80 })

class Command
  constructor: ->
    env = envalid.cleanEnv envConfig
    @serverOptions = {
      meshbluConfig:  new MeshbluConfig().toJSON()
      port: env.PORT
    }

  panic: (error) =>
    console.error error.stack
    process.exit 1

  run: =>
    @panic new Error('Missing meshbluConfig') if _.isEmpty @serverOptions.meshbluConfig

    server = new Server @serverOptions
    server.run (error) =>
      return @panic error if error?

      {port} = server.address()
      console.log "<%= serviceClass %> listening on port: #{port}"

    sigtermHandler = new SigtermHandler()
    sigtermHandler.register server.stop

command = new Command()
command.run()
