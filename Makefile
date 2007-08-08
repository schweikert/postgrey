MAJOR = 1
MINOR = 30
VERSION = $(MAJOR).$(MINOR)

all: tag-build

tag-build: version tag merge build

version:
	perl -pi -e 's|^my \$$VERSION.*|my \$$VERSION = '"'"'$(VERSION)'"'"';|' postgrey

tag:
	@svk st | grep 'M' >/dev/null; \
		if [ $$? -eq 0 ]; then \
			echo "Commit your changes!"; \
			exit 1; \
		fi
	@if svk ls //postgrey/tags/version-$(MAJOR).$(MINOR) >/dev/null; then \
		echo "Tag version-$(MAJOR).$(MINOR) already exists!"; \
		exit 1; \
	fi
	svk cp -m 'Tag version $(MAJOR).$(MINOR)' //postgrey/trunk //postgrey/tags/version-$(MAJOR).$(MINOR)

merge:
	svk smerge -I -f //postgrey

build:
	mkdir -p postgrey-$(VERSION)
	tar cf - --files-from MANIFEST | (cd postgrey-$(VERSION) && tar xf -)
	[ -d pub ] || mkdir pub
	tar czf pub/postgrey-$(VERSION).tar.gz postgrey-$(VERSION)
	rm -r postgrey-$(VERSION)

.PHONY: all tag-build version tag merge build
