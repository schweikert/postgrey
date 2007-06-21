MAJOR = 1
MINOR = 27
VERSION = $(MAJOR).$(MINOR)
PUB=/usr/tardis/netvar/websites/isg-tools/postgrey/pub

version:
	perl -pi -e 's|^my \$$VERSION.*|my \$$VERSION = '"'"'$(VERSION)'"'"';|' postgrey

tarball: pub/postgrey-$(VERSION).tar.gz

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

pub/postgrey-$(VERSION).tar.gz: version
	mkdir -p postgrey-$(VERSION)/contrib
	./isgtc_to_public postgrey >postgrey-$(VERSION)/postgrey
	chmod +x postgrey-$(VERSION)/postgrey
	cp COPYING Changes README README.exim postgrey-$(VERSION)
	cp postgrey_whitelist_clients postgrey-$(VERSION)
	cp postgrey_whitelist_recipients postgrey-$(VERSION)
	cp contrib/postgreyreport postgrey-$(VERSION)/contrib
	[ -d pub ] || mkdir pub
	gtar czf pub/postgrey-$(VERSION).tar.gz postgrey-$(VERSION)
	rm -r postgrey-$(VERSION)

publish: pub/postgrey-$(VERSION).tar.gz
	svn copy svn://svn.schweikert.ch/isgtc-src/trunk/postgrey svn://svn.ee.ethz.ch/isgtc-src/tags/postgrey/release-$(VERSION) || true
	mv $(PUB)/*.tar.gz $(PUB)/old
	cp Changes pub/postgrey-$(VERSION).tar.gz $(PUB)

.PHONY: version publish tarball
