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

map = require 'map-stream'
gutil = require 'gulp-util'
promise = require 'promise'
_ = require 'lodash'
fs = require 'fs'


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


files = []

gulp.task 'compile:js', ->
  (new Promise (resolve, reject) ->
    gulp.src '**/models/*.coffee'
      .pipe map (file, callback) ->
        # gutil.log file.path
        filePath = file.path
        fileName = (filePath.split '/models/')[1]
        file = (fileName.split '.')[0]
        files.push file
        # gutil.log files
        callback(false, file)
      .on 'end', resolve
  ).then () ->
    requirePaths = _.map files, (file) ->
      "models/#{file}.coffee"
    formatted = _.map files, (file) ->
      split = _.map (file.split "-"), (i) ->
        i[0].toUpperCase() + i.substring(1)
      split.join("");
    zipped = _.zip formatted, requirePaths
    classMap = _.map zipped, (pair) ->
      "  '#{pair[0]}': require \'#{pair[1]}\'"
    classMap = classMap.join "\n"
    result = "module.exports =\n#{classMap}"
    fs.writeFile 'app/util/model-class-map.coffee', result
    # clear the files for the next build
    files = []

  compiler = browserify 'app.coffee', basedir: src, debug: true, paths: ['./']
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
