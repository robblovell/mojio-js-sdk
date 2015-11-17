// Generated by CoffeeScript 1.10.0
(function() {
  var coffee, coffeeFiles, gulp, gutil, handleError, jsdoc, nodeJsFiles, parallelize, path, sourcemaps, tap, threads, touch, useSourceMaps;

  gulp = require('gulp');

  gutil = require('gulp-util');

  coffee = require('gulp-coffee');

  sourcemaps = require('gulp-sourcemaps');

  touch = require('touch');

  path = require('path');

  tap = require('gulp-tap');

  jsdoc = require('gulp-jsdoc');

  parallelize = require("concurrent-transform");

  threads = 100;

  useSourceMaps = true;

  coffeeFiles = ['./*.coffee', './test/**/*.coffee', './unittests/**/*.coffee', './src/**/*.coffee', 'test/**/*.coffee', 'example/**/*.coffee', 'examples/**/*.coffee'];

  nodeJsFiles = './src/nodejs/*.js';

  handleError = function(err) {
    console.log(err.toString());
    return this.emit('end');
  };

  gulp.task('touch', function() {
    return gulp.src(coffeeFiles).pipe(tap(function(file, t) {
      return touch(file.path);
    }));
  });

  gulp.task('docs', function() {
    return gulp.src(nodeJsFiles).pipe(jsdoc('./docs'));
  });

  gulp.task('coffeescripts', function() {
    return gulp.src(coffeeFiles).pipe(parallelize(coffee({
      bare: true
    }).on('error', gutil.log), threads)).pipe(parallelize((useSourceMaps ? sourcemaps.init() : gutil.noop()), threads));
  });

  gulp.task('watch', function() {
    return gulp.watch(coffeeFiles, ['coffeescripts']);
  });

  gulp.task('default', ['watch', 'coffeescripts']);

  gulp.task('done', (function() {}));

}).call(this);

//# sourceMappingURL=gulpfile.js.map
