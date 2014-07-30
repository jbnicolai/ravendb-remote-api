os = require 'os'
_ = require 'lodash'

module.exports = (grunt) ->
  require('time-grunt')(grunt)
  require('load-grunt-tasks')(grunt)
  
  DS = if os.platform().toLowerCase() is 'darwin' then '/' else '\\'

  mochaTest = [
    ".#{DS}node_modules#{DS}.bin#{DS}mocha "
    "--reporter list --compilers "
    ".#{DS}node_modules#{DS}.bin#{DS}coffee"
    ":coffee-script#{DS}register "
    ".#{DS}test#{DS}mocha-globals.coffee "
    "--recursive "
    ".#{DS}test#{DS}unit#{DS}*.Spec.* "
  ].join('')

  coffeeFile = [
    './src/*.coffee'
    './src/**/*.coffee'
    './src/**/**/*.coffee'
    './src/**/**/**/*.coffee'
    './src/**/**/**/**/*.coffee'
  ]

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    #==============================================================================
    # Clean
    #==============================================================================
    clean:
      all: ['dist', 'build', 'lib']

    #==============================================================================
    # coffeelint
    #==============================================================================
    coffeelint:
      dev:
        files:
          src: coffeeFile
        options:
          'max_line_length':
            'level': 'ignore'
    
    #==============================================================================
    # coffeelint
    #==============================================================================
    coffee:
      dev:
        options:
          bare: true
        expand: true
        flatten: true
        cwd: './'
        src: coffeeFile
        dest: './lib/'
        ext: '.js'

    #==============================================================================
    # shell
    #==============================================================================
    shell:
      mocha:
        command: mochaTest
        options:
          async: true
      publish:
        command: "npm publish"
    #==============================================================================
    # dump version
    #==============================================================================
    bump:
      options:
        files: ['package.json'],
        updateConfigs: [],
        commit: true,
        commitMessage: 'Release v%VERSION%',
        commitFiles: ['package.json'],
        createTag: true,
        tagName: 'v%VERSION%',
        tagMessage: 'Version %VERSION%',
        push: true,
        pushTo: 'origin master',
        gitDescribeOptions: '--tags --always --abbrev=1 --dirty=-d'

    #==============================================================================
    # concurrent
    #==============================================================================
    concurrent:
      dev:
        tasks: ['watch:server']
        options:
          logConcurrentOutput: true
      test:
        tasks: ['shell:mocha']
        options:
          logConcurrentOutput: true

    #==============================================================================
    # watch
    #==============================================================================
    watch:
      dev:
        files: coffeeFile
        tasks: ['build']

    #==============================================================================
    # Task
    #==============================================================================
    grunt.registerTask('runCoffee', [
      'coffeelint:dev'
      'coffee:dev'
    ])
    grunt.registerTask('build', [
      'clean:all'
      'runCoffee'
      'test'
    ])
    grunt.registerTask('dev', ['watch:dev'])
    grunt.registerTask('test', ['concurrent:test'])
    grunt.registerTask('default', ['clean:all'])

    grunt.registerTask "release", "Release a new version, push it and publish", (target) ->
        runTask = ["build"]
        if target is 'bump'
          runTask.push 'bump'

        if target is 'patch'
          runTask.push 'bump:patch'

        if target is 'minor'
          runTask.push 'bump:minor'

        if target is 'major'
          runTask.push 'bump:major'

        if target is 'dev'
          runTask.push 'bump:prerelease'

        if target is 'git'
          runTask = ['runCoffee','bump:git']

        unless target
          runTask.concat ["bump:patch","shell:publish"]

        grunt.task.run runTask

