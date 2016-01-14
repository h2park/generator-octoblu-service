Controller = require './controllers/controller'

class Router
  constructor: ({@service}) ->
  route: (app) =>
    controller = new Controller {@service}

    app.get '/hello', controller.hello
    # e.g. app.put '/resource/:id', someController.update

module.exports = Router
