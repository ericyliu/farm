let autoprefixer = require('autoprefixer-stylus');
let browserify = require('browserify');
let browserifyNgAnnotate = require('browserify-ngannotate');
let colors = require('colors/safe');
let concat = require('gulp-concat');
let connect = require('gulp-connect');
let del = require('del');
let gulp = require('gulp');
let jade = require('gulp-jade');
let path = require('path');
let replace = require('gulp-replace');
let source = require('vinyl-source-stream');
let stylus = require('gulp-stylus');

let map = require('map-stream');
let gutil = require('gulp-util');
let promise = require('promise');
let _ = require('lodash');
let fs = require('fs');


let dest = 'dist';
let env = 'local';
let src = 'app';
let watch = false;


let catchErrors = compiler =>
  compiler.on('error', function(err) {
    if (watch) {
      console.error(colors.red(err));
      return this.emit('end');
    } else {
      throw err;
    }
  })
;


gulp.task('compile:jade', () =>
  gulp.src('**/*.jade', {base: src, cwd: src})
    .pipe(catchErrors(jade({locals: {env}})))
    .pipe(gulp.dest('dist'))
    .pipe(connect.reload())
);


let files = [];

gulp.task('compile:js', function() {
  (new Promise((resolve, reject) =>
    gulp.src('**/app/models/*.js')
      .pipe(map(function(file, callback) {
        // gutil.log file.path
        let filePath = file.path;
        let splitFilePath = filePath.split('/models/');
        // to deal with fucking windows paths
        if (splitFilePath.length === 1) {
            // this was a windows path with backslashes
          splitFilePath = filePath.split('\\models\\');
        }
        let fileName = splitFilePath[1];
        gutil.log(filePath);
        gutil.log(splitFilePath);
        gutil.log(fileName);
        file = (fileName.split('.'))[0];
        files.push(file);
        // gutil.log files
        return callback(false, file);
      })
    )
      .on('end', resolve)
  )).then(function() {
    let requirePaths = _.map(files, file => `models/${file}.js`);
    let formatted = _.map(files, function(file) {
      let split = _.map((file.split("-")), i => i[0].toUpperCase() + i.substring(1));
      return split.join("");
    });
    let zipped = _.zip(formatted, requirePaths);
    let classMap = _.map(zipped, pair => `  ${pair[0]}: require(\'${pair[1]}\'),`);
    classMap = classMap.join("\n");
    let result = `module.exports = {\n${classMap}\n}`;
    fs.writeFile('app/util/model-class-map.js', result);
    // clear the files for the next build
    return files = [];});

  let compiler = browserify('app.js', {basedir: src, debug: true, paths: ['./']})

    // !!! eric do we need this NgAnnotate thing still?

    // .transform(browserifyNgAnnotate, {ext: '.js'})
    .bundle();

  return catchErrors(compiler)
    .pipe(source('app.js'))
    // .pipe(replace(/'ngInject';/g, ''))
    .pipe(gulp.dest('dist'))
    .pipe(connect.reload());
});



gulp.task('compile:stylus', function() {
  let includePath = path.join(__dirname, 'app', 'shared', 'styles');
  return gulp.src('**/*.styl', {cwd: src})
    .pipe(catchErrors(stylus({use: [autoprefixer()], paths: [includePath]})))
    .pipe(concat('app.css'))
    .pipe(gulp.dest('dist'))
    .pipe(connect.reload());
});


gulp.task('copy:assets', () =>
  gulp
    .src('assets/**/*', {base: src, cwd: src})
    .pipe(gulp.dest('dist'))
    .pipe(connect.reload())
);


gulp.task('copy:favicon', () =>
  gulp
    .src('assets/favicon.ico', {base: '', cwd: src})
    .pipe(gulp.dest('dist'))
);


gulp.task('build:local', [
  'compile:jade', 'compile:js', 'compile:stylus',
  'copy:assets', 'copy:favicon'
]);


gulp.task('serve:local', ['build:local'], () => connect.server({livereload: watch, port: 8000, root: dest}));


gulp.task('watch', function() {
  watch = true;
  gulp.start('serve:local');
  gulp.watch(['app/**/*.jade'], ['compile:jade']);
  gulp.watch(['app/**/*.js', '!**/*_spec.js'], ['compile:js']);
  // gulp.watch(['app/**/*.js', '!**/*_spec.js'], ['compile:js']);
  gulp.watch('app/**/*.styl', ['compile:stylus']);
  return gulp.watch('app/assets/**/*', ['copy:assets']);});


gulp.task('clean', () => del('dist'));


gulp.task('default', ['watch']);
