autoprefixer = require 'gulp-autoprefixer'
cached = require 'gulp-cached'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
eventStream = require 'event-stream'
fs = require 'fs'
gcson = require 'gulp-cson'
gulp = require 'gulp'
ngAnnotate = require 'gulp-ng-annotate'
rename = require 'gulp-rename'
run = require 'gulp-run'
sass = require 'gulp-ruby-sass'
slim = require 'gulp-slim'
sourcemaps = require 'gulp-sourcemaps'
notify = require 'gulp-notify'
yargs = require 'yargs'

argv = yargs.argv

bowerJavaScript = [
  'underscore/underscore.js'
  'jquery/dist/jquery.js'
  'jquery-ui/jquery-ui.js'
  'bootstrap/dist/js/bootstrap.js'
  'angular/angular.js'
  'angular-resource/angular-resource.js'
  'ui-router/release/angular-ui-router.js'
  'qrcode-generator/js/qrcode.js'
  'angular-qrcode/qrcode.js'
  'angular-ui-grid/ui-grid.js'
  'angular-bootstrap/ui-bootstrap-tpls.js'
  'angular-busy/dist/angular-busy.js'
]

vendorJavaScript = [
  'live.js'
]

bowerCss = [
  'angular-busy/dist/angular-busy.css'
  'jquery-ui/themes/base/all.css'
  'jquery-ui/themes/base/resizable.css'
]

swallowError = (err) ->
  console.log(err.toString())
  @emit 'end'

gulp.task 'bower:js', ->
  gulp.src([].concat(
    ("bower_components/#{fname}" for fname in bowerJavaScript),
    ("vendor/#{fname}" for fname in vendorJavaScript)))
    .pipe(concat('vendor.js').on('error', swallowError))
    .pipe(gulp.dest('dist'))

# If you uglify this you need to make it angular dependency injection aware
gulp.task 'coffee', ->
  gulp.src(('src/**/*.coffee'))
    .pipe(sourcemaps.init())
    .pipe(coffee().on('error', swallowError))
    .pipe(ngAnnotate())
    .pipe(concat('app.js').on('error', swallowError))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('dist'))

gulp.task 'slim', ->
  gulp.src(('src/**/*.slim'))
    .pipe(cached('slim'))
    .pipe(rename((path) ->
      path.dirname = path.dirname.replace(/^(html|js)(\/|$)/, '')
      path
    ))
    .pipe(slim(pretty: true))
    .pipe(gulp.dest('dist'))

gulp.task 'icons', ->
  gulp.src('bower_components/fontawesome/fonts/**.*')
    .pipe(gulp.dest('dist/fonts'))

gulp.task 'css', ->
  bowerFiles = gulp.src(("bower_components/#{fname}" for fname in bowerCss))

  sassFiles = sass('src/app.scss', {
    loadPath: [
      'bower_components/bootstrap-sass-official/assets/stylesheets'
      'bower_components/fontawesome/scss'
    ]
  }).on('error', swallowError)
    .pipe(sourcemaps.write())

  eventStream.concat(bowerFiles, sassFiles)
    .pipe(concat('app.css'))
    .pipe(gulp.dest("dist"))

gulp.task 'build', ['coffee', 'slim', 'bower:js', 'css', 'icons']

gulp.task 'watch', ->
  gulp.watch 'src/**/*.coffee', ['coffee']
  gulp.watch 'src/**/*.slim', ['slim']
  gulp.watch 'src/**/*.scss', ['css']

gulp.task 'dev', ['build', 'watch']

gulp.task 'default', ['dev']
