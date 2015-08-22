gulp        = require 'gulp'
gutil       = require 'gulp-util'
rename      = require 'gulp-rename'
browserify  = require 'browserify'
watchify    = require 'watchify'
coffeeify   = require 'coffeeify'
source      = require 'vinyl-source-stream'
{ fork }    = require 'child_process'
coffee      = require 'gulp-coffee'

srcDir      = 'public/src/'
entryFile   = 'index.coffee'
entryPath   = srcDir + entryFile
node        = null

browserifyResult = browserify entryPath,
    paths: srcDir
    extensions: [ '.coffee' ]
    transform: [ coffeeify ]

bundleAndPipe = (result, cb) ->
    result
    .bundle()
    .on 'error', gutil.log
    .pipe source entryFile
    .pipe rename
        extname: '.bundle.js'
    .pipe gulp.dest 'public/bundles/'

gulp.task 'prepare', [ 'compile-server' ], -> bundleAndPipe browserifyResult

gulp.task 'compile-server', (cb) ->
    gulp
    .src 'app.coffee'
    .pipe coffee { bare: yes }
    .on 'error', gutil.log
    .pipe gulp.dest 'lib'

gulp.task 'start-server', [ 'compile-server' ], (cb) ->
    node?.kill()
    node = fork 'lib/app.js', stdio: 'inherit'
    cb()

gulp.task 'watch', [ 'start-server'], ->

    bundler = watchify browserifyResult

    bundler
    .on 'update', (file) ->
        gutil.log "#{file} changed"
        bundleAndPipe bundler
    .on 'log', gutil.log

    bundleAndPipe bundler

    gulp.watch 'app.coffee', [ 'start-server' ]

# If the gulp process closes unexpectedly, kill the server
process.on 'exit', -> node?.kill()