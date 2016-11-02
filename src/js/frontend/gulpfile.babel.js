import gulp from "gulp"
import path from "path"
import config from "./config"
import buildStylesheetsHelper from "@n3dst4/build-stylesheets"
import browserBundleHelper from "@n3dst4/browser-bundle"
import browserSync from "browser-sync"

// this helps in development, when you may have used `npm link` to work on
// something which has a peer dependency on something in our local node_modules
try {
    process.env.NODE_PATH = "./node_modules";
    // _initPaths is a private API, so this could easily break in future
    // versions
    require("module").Module._initPaths();
}
catch (err) {
    console.warn("Failed to set NODE_PATH programatically - linked packages " +
                 "may not work if they have peerDependencies in this folder. " +
                 "See http://stackoverflow.com/a/33886121/212676")
}

const bs = browserSync.create()
const production = process.env.NODE_ENV === "production"

function browserBundle (opts = {}) {
  opts.production = production
  const bundleStream =  browserBundleHelper("src/main.js", "__generated/js/main.js", opts)
  bundleStream.on("updated", bs.reload)
  return bundleStream
}

gulp.task("default", ["build"])

gulp.task("build", ["build-html", "build-stylesheets", "build-scripts"])

gulp.task("build-scripts", function () {
  return browserBundle()
})

gulp.task("build-html", function () {
  return gulp.src("pages/*.html").pipe(gulp.dest(config.buildFolder)).pipe(bs.stream())
})

gulp.task("build-stylesheets", () => {
  return gulp.src(path.join("stylesheets", "main.less")).
    pipe(buildStylesheetsHelper({
      src: "stylesheets",
      dest: "__generated/css/assets",
      prefix: "assets/"
    }, production)).
    pipe(gulp.dest(path.join("__generated", "css"))).
    pipe(bs.stream({match: "**/*.css"}))
})

gulp.task("watch", ["build-scripts", "build-html"], function() {
  browserBundle({watch: true})
  gulp.watch(['config.json'], ['build-scripts', 'build-html'])
  gulp.watch(["pages/**/*.html"], ['build-html'])
  gulp.watch(["stylesheets/**/*.less"], ['build-stylesheets'])
})

gulp.task('webserver', function() {
  bs.init({
    server: {baseDir: "./__generated/"},
    reloadDelay: 0,
    ghostMode: false,
    reloadOnRestart: false,
    notify: false
  })
})

gulp.task("develop", ["watch", "webserver"])
