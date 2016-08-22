class <%= controllerClass %>
  constructor: ({@<%= serviceInstance %>}) ->
    throw new Error 'Missing <%= serviceInstance %>' unless @<%= serviceInstance %>?

  hello: (request, response) =>
    {hasError} = request.query
    @<%= serviceInstance %>.doHello {hasError}, (error) =>
      return response.sendError(error) if error?
      response.sendStatus(200)

module.exports = <%= controllerClass %>
