util = require 'util'
path = require 'path'
url = require 'url'
GitHubApi = require 'github'
yeoman = require 'yeoman-generator'

extractGeneratorName = (_, appname) ->
  _.slugify appname

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
      default: 'someuser'
    ,
      name: 'generatorName'
      message: 'What\'s the base name of your generator?'
      default: generatorName
    ]

    @prompt prompts, (props) =>
      @githubUser = props.githubUser
      @generatorName = props.generatorName
      @appname = @generatorName
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
    @template '_package.json', 'package.json'
    @template 'src/_server.coffee', 'src/server.coffee'
    @template 'src/_router.coffee', 'src/router.coffee'
    @template 'test/integration/_sample-integration-spec.coffee', 'test/integration/sample-integration.coffee'
    @template '_index.js', 'index.js'
    @template '_command.js', 'command.js'
    @template '_command.coffee', 'command.coffee'
    @template '_travis.yml', '.travis.yml'
    @template '_Dockerfile', 'Dockerfile'
    @template '_dockerignore', '.dockerignore'
    @template 'README.md'
    @template 'LICENSE'

  gitfiles: ->
    @copy '_gitignore', '.gitignore'

  app: ->

  templates: ->

  tests: ->

module.exports = OctobluServiceGenerator
