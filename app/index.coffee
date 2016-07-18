util      = require 'util'
path      = require 'path'
url       = require 'url'
GitHubApi = require 'github'
yeoman    = require 'yeoman-generator'
_         = require 'lodash'

extractGeneratorName = (__, appname) ->
  _.kebabCase appname

githubUserInfo = (name, cb) ->
  github = new GitHubApi version: '3.0.0'
  github.user.getFrom user: name, cb

class OctobluServiceGenerator extends yeoman.generators.Base
  constructor: (args, options, config) ->
    super
    @currentYear = (new Date()).getFullYear()
    {@realname, @githubUrl} = options
    @on 'end', => @installDependencies skipInstall: options['skip-install']
    @pkg = JSON.parse @readFileAsString path.join __dirname, '../package.json'

  askFor: ->
    # have Yeoman greet the user.
    console.log @yeoman

    done = @async()
    generatorName = extractGeneratorName @_, @appname

    prompts = [
      name: 'githubUser'
      message: 'Would you mind telling me your username on GitHub?'
      default: 'octoblu'
    ,
      name: 'generatorName'
      message: 'What\'s the base name of your generator?'
      default: generatorName
    ]

    @prompt prompts, (props) =>
      @githubUser = props.githubUser
      @generatorName = props.generatorName
      done()

  userInfo: ->
    return if @realname? and @githubUrl?

    done = @async()

    githubUserInfo @githubUser, (err, res) =>
      @realname = res.name
      @email = res.email
      @githubUrl = res.html_url
      done()

  projectfiles: ->
    appName = _.kebabCase @generatorName
    generatorNameWithoutService = @generatorName.replace(/\-service$/, '')
    fullFilePrefix = _.kebabCase @generatorName
    filePrefix = _.kebabCase generatorNameWithoutService
    instancePrefix = _.camelCase generatorNameWithoutService
    classPrefix = _.upperFirst instancePrefix

    serviceClass    = "#{classPrefix}Service"
    serviceInstance = "#{instancePrefix}Service"

    controllerClass = "#{classPrefix}Controller"
    controllerInstance = "#{instancePrefix}Controller"

    context = {
      filePrefix
      serviceClass
      serviceInstance
      controllerClass
      controllerInstance
      appName
      fullFilePrefix
      @githubUrl
      @realname
    }
    @template "_package.json", "package.json", context
    @template "src/_server.coffee", "src/server.coffee", context
    @template "src/_router.coffee", "src/router.coffee", context
    @template "src/services/_service.coffee", "src/services/#{filePrefix}-service.coffee", context
    @template "src/controllers/_controller.coffee", "src/controllers/#{filePrefix}-controller.coffee", context
    @template "test/_mocha.opts", "test/mocha.opts", context
    @template "test/_test_helper.coffee", "test/test_helper.coffee", context
    @template "test/integration/_hello-spec.coffee", "test/integration/#{filePrefix}-hello-spec.coffee", context
    @template "_index.js", "index.js", context
    @template "_command.js", "command.js", context
    @template "_command.coffee", "command.coffee", context
    @template "_travis.yml", ".travis.yml", context
    @template "_Dockerfile", "Dockerfile", context
    @template "_dockerignore", ".dockerignore", context
    @template "README.md", "README.md", context
    @template "LICENSE", "LICENSE", context

  gitfiles: ->
    @copy '_gitignore', '.gitignore'

  app: ->

  templates: ->

  tests: ->

module.exports = OctobluServiceGenerator
