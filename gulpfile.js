var gulp = require('gulp');

var coffee = require('gulp-coffee');
var haml = require('gulp-haml');
var sass = require('gulp-sass');
var rjs = require('gulp-requirejs');
var uglify = require('gulp-uglifyjs');

var version = '0.1.1'

var paths = {
  scripts: [
  	'src/coffee/**/*.coffee'
  ],
  haml: ['src/haml/**/*.haml'],
  sass: ['src/scss/**/*.scss']
};

gulp.task('build', ['scripts', 'haml', 'sass'], function() {
  rjs({
	baseUrl: 'public',
	name: 'js/main',
	out: "./build/gamework.min.js",
	paths: {
	    jquery: "./vendor/jquery-1.11.1.min",
	    underscore: "./vendor/underscore-min",
	    easel: "./vendor/easeljs-0.7.1.min",
	    preload: "./vendor/preloadjs-0.4.1.min",
	    sound: "./vendor/soundjs-0.5.2.min",
	    tween: "./vendor/tweenjs-0.5.1.min",
	    config: "./js/config",
	    scenes: "./js/gamework/views/scenes",
	    views: "./js/gamework/views",
    	helpers: "./js/gamework/helpers",
	    gamework: './js/gamework/gamework',
	    layouts: "./js/app/layouts",
	    game: "./js/professions/index",
	    simplegame: "./js/simplegame",
	    professions: "./js/professions"
  	},
    shim: {
      jquery: {
        exports: 'jQuery'
      },
      underscore: {
        exports: '_'
      },
      easel: {
        deps: ['preload', 'tween', 'sound'],
        exports: 'easel'
      }
    }
  }).pipe(gulp.dest('public/js'))
});

gulp.task('uglify', function() {
  gulp.src('public/js/build/gamework.min.js')
    .pipe(uglify())
    .pipe(gulp.dest('public/js/build'))
});

gulp.task('scripts', function() {
  return gulp.src(paths.scripts)
    .pipe(coffee({bare: true}))
    .pipe(gulp.dest('public/js'));
});

gulp.task('haml', function () {
  gulp.src(paths.haml)
    .pipe(haml({ext: '.html'}))
    .pipe(gulp.dest('public/'));
});

gulp.task('sass', function () {
    gulp.src(paths.sass)
	    .pipe(sass())
	    .pipe(gulp.dest('public/css'));
});

// Rerun the task when a file changes
gulp.task('watch', function() {
  gulp.watch(paths.scripts, ['scripts']);
  gulp.watch(paths.haml, ['haml']);
  gulp.watch(paths.sass, ['sass']);
});

// The default task (called when you run `gulp` from cli)
gulp.task('default', ['scripts', 'haml', 'sass', 'watch']);
