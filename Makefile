VERSION = 1.6

tarball:
	mkdir -p postgrey-$(VERSION)
	env VERSION=$(VERSION) \
		./isgtc_to_public postgrey >postgrey-$(VERSION)/postgrey
	chmod +x postgrey-$(VERSION)/postgrey
	cp COPYING Changes README postgrey-$(VERSION)
	cp postgrey_client_access postgrey-$(VERSION)
	[ -d pub ] || mkdir pub
	gtar czf pub/postgrey-$(VERSION).tar.gz postgrey-$(VERSION)
	rm -r postgrey-$(VERSION)
