'use strict';

module.exports = function(grunt) {

  var path = require('path'),
      server = require('./lib/server')(grunt);
  
  grunt.registerTask('coffeeserver', 'Start an express web server', function() {
    var options = this.options({
      coffee_cmd: 'coffee', 
      port: 3000
    });

    options.script = path.resolve(options.script);
    
    if (!grunt.file.exists(options.script)) {
      grunt.log.error('Could not find server script: ' + options.script);
      return false;
    }

    server.start(options);
  });

};