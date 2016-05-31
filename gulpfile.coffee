autoprefixer = require 'autoprefixer-stylus'
browserify = require 'browserify'
browserifyNgAnnotate = require 'browserify-ngannotate'
coffeeify = require 'coffeeify'
colors = require 'colors/safe'
concat = require 'gulp-concat'
connect = require 'gulp-connect'
del = require 'del'
gulp = require 'gulp'
jade = require 'gulp-jade'
path = require 'path'
replace = require 'gulp-replace'
source = require 'vinyl-source-stream'
stylus = require 'gulp-stylus'


dest = 'dist'
env = 'local'
src = 'app'
watch = false


catchErrors = (compiler) ->
  compiler.on 'error', (err) ->
    if watch
      console.error colors.red(err)
      @emit 'end'
    else
      throw err


gulp.task 'compile:jade', ->
  gulp.src '**/*.jade', base: src, cwd: src
    .pipe catchErrors jade(locals: {env})
    .pipe gulp.dest 'dist'
    .pipe connect.reload()


gulp.task 'compile:js', ->
  compiler = browserify 'app.coffee', basedir: src, debug: true
    .transform coffeeify
    .transform browserifyNgAnnotate, ext: '.coffee'
    .bundle()

  catchErrors compiler
    .pipe source 'app.js'
    .pipe replace /'ngInject';/g, ''
    .pipe gulp.dest 'dist'
    .pipe connect.reload()


gulp.task 'compile:stylus', ->
  includePath = path.join(__dirname, 'app', 'shared', 'styles')
  gulp.src '**/*.styl', cwd: src
    .pipe catchErrors stylus(use: [autoprefixer()], paths: [includePath])
    .pipe concat 'app.css'
    .pipe gulp.dest 'dist'
    .pipe connect.reload()


gulp.task 'copy:assets', ->
  gulp
    .src 'assets/**/*', base: src, cwd: src
    .pipe gulp.dest 'dist'
    .pipe connect.reload()


gulp.task 'copy:favicon', ->
  gulp
    .src 'assets/favicon.ico', base: '', cwd: src
    .pipe gulp.dest 'dist'


gulp.task 'build:local', [
  'compile:jade', 'compile:js', 'compile:stylus',
  'copy:assets', 'copy:favicon'
]


gulp.task 'serve:local', ['build:local'], ->
  connect.server livereload: watch, port: 8000, root: dest


gulp.task 'watch', ->
  watch = true
  gulp.start 'serve:local'
  gulp.watch ['app/**/*.jade'], ['compile:jade']
  gulp.watch ['app/**/*.coffee', '!**/*_spec.coffee'], ['compile:js']
  gulp.watch 'app/**/*.styl', ['compile:stylus']
  gulp.watch 'app/assets/**/*', ['copy:assets']


gulp.task 'clean', ->
  del 'dist'


gulp.task 'default', ['watch']
