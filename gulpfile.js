var gulp = require('gulp');

var coffee = require('gulp-coffee');
var haml = require('gulp-haml');
var sass = require('gulp-sass');

var paths = {
  scripts: [
  	'src/coffee/**/*.coffee'
  ],
  haml: ['src/haml/**/*.haml'],
  sass: ['src/scss/**/*.scss']
};


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