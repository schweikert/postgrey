VERSION = 1.7

tarball:
	mkdir -p postgrey-$(VERSION)/contrib
	env VERSION=$(VERSION) \
		./isgtc_to_public postgrey >postgrey-$(VERSION)/postgrey
	chmod +x postgrey-$(VERSION)/postgrey
	cp COPYING Changes README postgrey-$(VERSION)
	cp postgrey_whitelist_clients postgrey-$(VERSION)
	cp postgrey_whitelist_recipients postgrey-$(VERSION)
	cp contrib/postgrey-report postgrey-$(VERSION)/contrib
	[ -d pub ] || mkdir pub
	gtar czf pub/postgrey-$(VERSION).tar.gz postgrey-$(VERSION)
	rm -r postgrey-$(VERSION)
