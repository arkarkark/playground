dev:
	echo http://localhost:4646/
	./node_modules/gulp/bin/gulp.js &
	@cd dist; python -m SimpleHTTPServer 4646 2>/dev/null

setup:
	mkdir -p dist vendor
	npm install
	./node_modules/bower/bin/bower install
	curl -s -o vendor/live.js http://www.livejs.com/live.js
