class <%= controllerClass %>
  constructor: ({@<%= serviceInstance %>}) ->

  hello: (request, response) =>
    {hasError} = request.query
    @<%= serviceInstance %>.doHello {hasError}, (error) =>
      return response.sendError(error) if error?
      response.sendStatus(200)

module.exports = <%= controllerClass %>
