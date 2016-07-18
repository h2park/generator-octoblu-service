path    = require 'path'
helpers = require 'yeoman-test'
assert  = require 'yeoman-assert'

GENERATOR_NAME = 'app'
DEST = path.join __dirname, '..', 'temp', "generator-#{GENERATOR_NAME}"

describe 'GeneratorOctobluService', ->
  before (done) ->
    helpers
      .run path.join __dirname, '..', 'app'
      .inDir DEST
      .withOptions
        realname: 'Sqrt of Saturn'
        githubUrl: 'https://github.com/sqrtofsaturn'
      .withPrompts
        githubUser: 'sqrtofsaturn'
        generatorName: GENERATOR_NAME
      .on 'end', done

  it 'creates expected files', ->
    assert.file '''
      .dockerignore
      Dockerfile
      src/server.coffee
      src/router.coffee
      src/controllers/app-controller.coffee
      src/services/app-service.coffee
      test/mocha.opts
      test/test_helper.coffee
      .gitignore
      index.js
      command.js
      command.coffee
      .gitignore
      .travis.yml
      LICENSE
      README.md
      package.json
    '''.split /\s+/g
