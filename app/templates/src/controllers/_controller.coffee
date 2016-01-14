class Controller
  constructor: ({@service}) ->

  hello: (request, response) =>
    @service.doHello (error) =>
      return response.status(error.code || 500).send(error: error.message) if error?
      response.sendStatus(200)

module.exports = Controller
