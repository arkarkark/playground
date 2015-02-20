dev:
	echo http://localhost:4545/
	./node_modules/gulp/bin/gulp.js &
	@cd dist; python -m SimpleHTTPServer 4545 2>/dev/null

setup:
	mkdir -p dist
	npm install
	bower install
	curl -s -o vendor/live.js http://www.livejs.com/live.js
