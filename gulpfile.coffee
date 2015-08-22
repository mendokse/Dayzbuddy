gulp        = require 'gulp'
gutil       = require 'gulp-util'
rename      = require 'gulp-rename'
browserify  = require 'browserify'
watchify    = require 'watchify'
source      = require 'vinyl-source-stream'
{ fork }    = require 'child_process'

srcDir      = 'public/src/'
entryFile   = 'index.js'
entryPath   = srcDir + entryFile
node        = null

browserifyResult = browserify entryPath, paths: srcDir

bundleAndPipe = (result, cb) ->
    result
    .bundle()
    .on 'error', gutil.log
    .pipe source entryFile
    .pipe rename
        extname: '.bundle.js'
    .pipe gulp.dest 'public/bundles/'

gulp.task 'bundle', -> bundleAndPipe browserifyResult

gulp.task 'start-server', (cb) ->
    node?.kill()
    node = fork 'app.js', stdio: 'inherit'
    cb()

gulp.task 'watch', ['start-server'], ->

    bundler = watchify browserifyResult

    bundler
    .on 'update', (file) ->
        gutil.log "#{file} changed"
        bundleAndPipe bundler
    .on 'log', gutil.log

    bundleAndPipe bundler

    gulp.watch 'app.js', ['start-server']

# If the gulp process closes unexpectedly, kill the server
process.on 'exit', -> node?.kill()