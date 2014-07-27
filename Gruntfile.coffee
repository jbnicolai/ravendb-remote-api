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
    grunt.registerTask('build', [
      'clean:all'
      'coffeelint:dev'
      'coffee:dev'
      'test'
    ])
    grunt.registerTask('dev', ['watch:dev'])
    grunt.registerTask('test', ['concurrent:test'])
    grunt.registerTask('default', ['clean:all'])
