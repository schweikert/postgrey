VERSION = 1.9
PUB=/usr/tardis/netvar/websites/isg-tools/postgrey/pub

version:
	perl -pi -e 's|^my \$$VERSION.*|my \$$VERSION = "$(VERSION)";|' postgrey

pub/postgrey-$(VERSION).tar.gz: version
	mkdir -p postgrey-$(VERSION)/contrib
	./isgtc_to_public postgrey >postgrey-$(VERSION)/postgrey
	chmod +x postgrey-$(VERSION)/postgrey
	cp COPYING Changes README postgrey-$(VERSION)
	cp postgrey_whitelist_clients postgrey-$(VERSION)
	cp postgrey_whitelist_recipients postgrey-$(VERSION)
	cp contrib/postgrey-report postgrey-$(VERSION)/contrib
	[ -d pub ] || mkdir pub
	gtar czf pub/postgrey-$(VERSION).tar.gz postgrey-$(VERSION)
	rm -r postgrey-$(VERSION)

publish: pub/postgrey-$(VERSION).tar.gz
	mv $(PUB)/*.tar.gz $(PUB)/old
	cp Changes pub/postgrey-$(VERSION).tar.gz $(PUB)

.PHONY: version publish
