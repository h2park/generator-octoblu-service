class <%= classPrefix %>Controller
  constructor: ({@<%= instancePrefix %>Service}) ->

  hello: (request, response) =>
    {hasError} = request.query
    @<%= instancePrefix %>Service.doHello {hasError}, (error) =>
      return response.status(error.code || 500).send(error: error.message) if error?
      response.sendStatus(200)

module.exports = <%= classPrefix %>Controller
