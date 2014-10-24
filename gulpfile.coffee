gulp = require 'gulp'
coffeeify = require 'gulp-coffeeify'
livereload = require 'gulp-livereload'

EXPRESS_PORT = 1337
EXPRESS_ROOT = './public/'
LIVERELOAD_PORT = 35729

gulp.task 'default', ['watchCoffee','server'], ->
	options =
		url: 'http://localhost:' + EXPRESS_PORT


	open = require 'gulp-open'
	gulp.src('./public/index.html').pipe(open('', options))
	console.log 'Watching...'

gulp.task 'watchCoffee', ->
   gulp.watch 'src/**/*.coffee', ['coffee2app']

gulp.task 'server', ['coffee2app'], ->
	express = require 'express'
	app = express()
	app.use(require('connect-livereload')())
	app.use(express.static(EXPRESS_ROOT))
	app.listen(EXPRESS_PORT)

	lr = require('tiny-lr')()
	lr.listen(LIVERELOAD_PORT)

	gulp.watch './public/src_js/index.js', (event) ->
		fileName = require('path').relative(EXPRESS_ROOT, event.path)
		lr.changed
			body:
				files: [fileName]

gulp.task 'coffee2app', ->
	gulp.src('src/**/*.coffee')
		.pipe(coffeeify())
		.pipe(gulp.dest('./public/src_js'))




