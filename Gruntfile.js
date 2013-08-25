/*global module:false*/
'use strict';
module.exports = function(grunt) {
  // Load local tasks
  grunt.loadTasks('tasks');

  // load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);
  
  // Project configuration.
  grunt.initConfig({
    // Task configuration.
    coffeelint: {
      coffee: {
        src: ['**/*.coffee']
      },
      calc_test: {
        src: ['**/*.coffee', '**/test/**/*.coffee']
      },
      options: {
        max_line_length: {
          level: 'ignore'
        },
        no_trailing_whitespace: {
          allowed_in_comments: true
        }
      }
    },

    watch: {
      coffee: {
        files: '<%= coffeelint.coffee.src %>',
        tasks: ['coffeelint:coffee']
      },
      calc_test: {
        files: '<%= coffeelint.calc_test.src %>',
        tasks: ['coffeelint:calc_test', 'simplemocha']
      },
      server: {
        files: '<%= coffeelint.coffee.src %>',
        tasks: ['coffeeserver'],
        options: {
          nospawn: true //Without this option specified express won't be reloaded
        }
      }
    },

    simplemocha: {
      options: {
        timeout: 3000,
        ignoreLeaks: false,
        ui: 'tdd',
        compilers: 'coffee:coffee-script'
      },
      all: {
        src: '**/test/**/*.coffee'
      }
    },

    coffeeserver: {
      options: {
        coffee_cmd: './node_modules/.bin/coffee',
        script: 'serve.coffee',
        delay: 100
      }
    }

  });

  grunt.registerTask('server', ['coffeeserver', 'watch:server']);
  grunt.registerTask('test', ['coffeelint', 'simplemocha']);
  grunt.registerTask('default', ['coffeelint', 'simplemocha', 'watch:calc_test']);

};
