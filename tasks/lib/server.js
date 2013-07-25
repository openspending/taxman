/*
 * coffee-server
 *
 * Inspriration and code was taken from grunt-express-server <https://github.com/ericclemmons/grunt-express-server>
 */

'use strict';

module.exports = function(grunt) {
  var done = null,
      server = null,
      backup_env = JSON.parse(JSON.stringify(process.env)); // Clone process.env

  var finished = function() {
    if (done) {
      done();
      
      done = null;
    }
  };

  return {
    start: function(options) {
      if (server) {
        this.stop();

        if (grunt.task.current.flags.stop) {
          finished();
          return;
        }
      }

      grunt.log.writeln('Starting '.cyan + 'Express server');

      done = grunt.task.current.async();

      process.env.PORT = options.port;
      
      server = grunt.util.spawn({
        cmd: options.coffee_cmd,
        args: [options.script],
        env: process.env
      }, function() {});
      
      if (options.delay) {
        setTimeout(finished, options.delay);
      }
      
      server.stdout.pipe(process.stdout);
      server.stderr.pipe(process.stderr);
      
      process.on('exit', finished);
      process.on('exit', this.stop);
      
    },
    stop: function() {
      if (server && server.kill) {
        grunt.log.writeln('Stopping '.red + 'Express server');
        server.kill('SIGTERM');
        process.removeAllListeners();
        server = null;
        
        process.env = JSON.parse(JSON.stringify(backup_env));
      }
      finished();
    }
  };
};