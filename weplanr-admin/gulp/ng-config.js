'use strict';

var path = require('path');
var  gulp = require('gulp');
var  conf = require('./conf');
var  gulpNgConfig = require('gulp-ng-config');

gulp.task('config', function () {
  gulp.src(path.join(conf.paths.src, '/app/index.base.json'))
    .pipe(gulpNgConfig('client', {
      environment: 'development'
    }))
    .pipe(gulp.dest(path.join(conf.paths.src, '/app/config/')))
});

gulp.task('config:build', function () {
  gulp.src(path.join(conf.paths.src, '/app/index.base.json'))
    .pipe(gulpNgConfig('client', {
      environment: 'production'
    }))
    .pipe(gulp.dest(path.join(conf.paths.src, '/app/config')))
});
