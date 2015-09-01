MAJOR   := 1
MINOR   := 36
VERSION := $(MAJOR).$(MINOR)
DATE    := $(shell date +%Y-%m-%d)

all: version tag build

version:
	perl -pi -e 's|^my \$$VERSION.*|my \$$VERSION = '"'"'$(VERSION)'"'"';|' postgrey

tag:
	git tag version-$(MAJOR).$(MINOR)

build:
	mkdir -p postgrey-$(VERSION)
	tar cf - --files-from MANIFEST | (cd postgrey-$(VERSION) && tar xf -)
	perl -pi -e 's{##VERSION##}{$(VERSION)}' postgrey-$(VERSION)/postgrey_whitelist_*
	perl -pi -e 's{##DATE##}{$(DATE)}' postgrey-$(VERSION)/postgrey_whitelist_*
	[ -d pub ] || mkdir pub
	tar czf pub/postgrey-$(VERSION).tar.gz postgrey-$(VERSION)
	rm -r postgrey-$(VERSION)

.PHONY: all version tag build
