http          = require 'http'
request       = require 'request'
enableDestroy = require 'server-destroy'
shmock        = require '@octoblu/shmock'
Server        = require '../../src/server'

xdescribe 'Sample Integration', ->
  beforeEach (done) ->
    @meshblu = shmock 0xd00d
    enableDestroy @meshblu

    serverOptions =
      port: undefined,
      disableLogging: true
      meshbluConfig:
        server: 'localhost'
        port: 0xd00d

    @server = new Server serverOptions

    @server.run =>
      @serverPort = @server.address().port
      done()

  afterEach ->
    @meshblu.destroy()
    @server.destroy()

  describe 'On POST /some/route', ->
    beforeEach (done) ->
      userAuth = new Buffer('user-uuid:user-token').toString 'base64'

      @meshblu
        .post '/authenticate'
        .set 'Authorization', "Basic #{userAuth}"
        .reply 200, uuid: 'user-uuid', token: 'user-token'

      @updateMeshbluDevice = @meshblu
        .patch '/v2/devices/some-device-uuid'
        .set 'Authorization', "Basic #{userAuth}"
        .send foo: 'bar'
        .reply 204

      options =
        uri: '/some/route'
        baseUrl: "http://localhost:#{@serverPort}"
        auth:
          username: 'user-uuid'
          password: 'user-token'
        json:
          uuid: 'some-device-uuid'
          foo: 'bar'

      request.post options, (error, @response, @body) =>
        done error

    it 'should return a 204', ->
      expect(@response.statusCode).to.equal 204

    it 'should auth handler', ->
      @authDevice.done()

    it 'should update the real device in meshblu', ->
      @updateMeshbluDevice.done()
