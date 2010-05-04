MAJOR = 1
MINOR = 33
VERSION = $(MAJOR).$(MINOR)

all: version tag build

version:
	perl -pi -e 's|^my \$$VERSION.*|my \$$VERSION = '"'"'$(VERSION)'"'"';|' postgrey

tag:
	hg tag version-$(MAJOR).$(MINOR)

build:
	mkdir -p postgrey-$(VERSION)
	tar cf - --files-from MANIFEST | (cd postgrey-$(VERSION) && tar xf -)
	[ -d pub ] || mkdir pub
	tar czf pub/postgrey-$(VERSION).tar.gz postgrey-$(VERSION)
	rm -r postgrey-$(VERSION)

.PHONY: all version tag build
