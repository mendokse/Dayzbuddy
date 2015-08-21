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

gulp.task 'start-server', (cb) ->
    node?.kill()
    node = fork 'app.js', stdio: 'inherit'
    cb()

gulp.task 'watch', ['start-server'], ->

    # Assets will be bundled when calling `.bundle()` on this object
    bundler = watchify browserify entryPath, paths: srcDir
    .on 'update', (file) ->
        gutil.log "#{file} changed"
        bundle() # When one the files changes, bundle again
    .on 'log', gutil.log

    # Bundles and handles moving of source files to the destination
    do bundle = ->
        bundler.bundle()
        .on 'error', gutil.log
        .pipe source entryFile
        .pipe rename
            extname: '.bundle.js'
        .pipe gulp.dest 'public/bundles/'

    gulp.watch 'app.js', ['start-server']

# If the gulp process closes unexpectedly, kill the server
process.on 'exit', -> node?.kill()