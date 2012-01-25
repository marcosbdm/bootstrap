VERSION=2.0.0
BOOTSTRAP = ./bootstrap.css
BOOTSTRAP_MIN = ./bootstrap.min.css
BOOTSTRAP_LESS = ./lib/bootstrap.less
LESS_COMPRESSOR ?= `which lessc`
UGLIFY_JS ?= `which uglifyjs`
WATCHR ?= `which watchr`
INOTIFYWAIT ?= `which inotifywait`

#
# Build less files
#

build:
	@@if test ! -z ${LESS_COMPRESSOR}; then \
		sed -e 's/@VERSION/'"v${VERSION}"'/' -e 's/@DATE/'"`date`"'/' <${BOOTSTRAP_LESS} >${BOOTSTRAP_LESS}.tmp; \
		lessc ${BOOTSTRAP_LESS}.tmp > ${BOOTSTRAP}; \
		lessc ${BOOTSTRAP_LESS}.tmp > ${BOOTSTRAP_MIN} --compress; \
		rm -f ${BOOTSTRAP_LESS}.tmp; \
		echo "Bootstrap successfully built! - `date`"; \
	else \
		echo "You must have the LESS compiler installed in order to build Bootstrap."; \
		echo "You can install it by running: npm install less -g"; \
	fi

#
# Watch less files with watchr
#

watch:
	@@if test ! -z ${WATCHR}; then \
	  echo "Watching less files..."; \
	  watchr -e "watch('lib/.*\.less') { system 'make' }"; \
	else \
		echo "You must have the watchr installed in order to watch Bootstrap Less files."; \
		echo "You can install it by running: gem install watchr"; \
	fi

#
# Watch less files with inotify
#

inotify:
	@@if test ! -z ${INOTIFYWAIT}; then \
		while inotifywait -e modify --timefmt '%d/%m/%y %H:%M' --format '%T %e %f' lib; do \
			make build && echo "=="; \
		done \
	else \
		echo "You must have the inotifywait installed in order to watch Bootstrap Less files."; \
		echo "You can get inotify-tools on github (https://github.com/rvoicilas/inotify-tools/wiki/)."; \
	fi

#
# Build docs from templates
#

docs:
	@ node docs/build


.PHONY: build watch inotify docs