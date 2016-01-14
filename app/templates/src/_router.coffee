Service = require './services/service'
Controller = require './controllers/controller'

class Router
  constructor: (options) ->
  route: (app) =>
    service = new Service
    controller = new Controller {service}

    app.get '/hello', controller.hello
    # e.g. app.put '/resource/:id', someController.update

module.exports = Router
