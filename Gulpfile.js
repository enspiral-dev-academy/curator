'use strict';
var coffee = require('gulp-coffee');
var gulp = require('gulp');
var istanbul = require('gulp-coffee-istanbul');
var gutil = require('gulp-util');
var mocha = require('gulp-mocha');
require('coffee-script/register');
var coverageEnforcer = require('gulp-istanbul-enforcer');
var path = require('path');

var globs = {
	js: {
		lib: ['curator.coffee', 'lib/*/*.coffee'],
		gulpfile: ['Gulpfile.js'],
		specs: ['test/*/*.coffee', '!test/fixtures/*']
	},
	specs: ['test/*/*.coffee', '!test/fixtures/*']
};

function mochaServer(options) {

	return gulp.src(globs.specs, {
			read: false
		})
		.pipe(mocha(options || {
			reporter: 'nyan',
			growl: true
		}));
}

var coverageOptions = {
	dir: './coverage',
	reporters: ['html', 'lcov', 'text-summary', 'html', 'json'],
	reportOpts: {
		dir: './coverage'
	}
};

gulp.task('mocha-server', function (cb) {
	gulp.src(globs.js.lib.concat(globs.specs))
		.pipe(istanbul())
		.pipe(istanbul.hookRequire())
		.on('finish', function () {
			mochaServer({
					reporter: 'spec'
				})
				.pipe(istanbul.writeReports(coverageOptions))
				.on('end', cb);
		});
});

gulp.task('test-debug', function () {
	var spawn = require('child_process').spawn;
	spawn('node', [
		'--debug-brk',
		path.join(__dirname, 'node_modules/gulp/bin/gulp.js'),
		'test'
	], {
		stdio: 'inherit'
	});
});

gulp.task('enforce-coverage', ['mocha-server'], function () {
	var options = {
		thresholds: {
			statements: 80,
			branches: 80,
			lines: 80,
			functions: 80
		},
		coverageDirectory: 'coverage',
		rootDirectory: process.cwd()
	};
	return gulp.src(globs.js.lib)
		.pipe(coverageEnforcer(options));
});

gulp.task('test', function () {
	return gulp.start(
		'enforce-coverage',
		'mocha-server'
	);
});

gulp.task('coffee', function () {
	gulp.src('./src/*.coffee')
		.pipe(coffee({
			bare: true
		}).on('error', gutil.log))
		.pipe(gulp.dest('./public/'));
});