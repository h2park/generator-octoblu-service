<%= classPrefix %>Controller = require './controllers/<%= filePrefix %>-controller'

class Router
  constructor: ({@<%= instancePrefix %>Service}) ->
  route: (app) =>
    <%= instancePrefix %>Controller = new <%= classPrefix %>Controller {@<%= instancePrefix %>Service}

    app.get '/hello', <%= instancePrefix %>Controller.hello
    # e.g. app.put '/resource/:id', someController.update

module.exports = Router
