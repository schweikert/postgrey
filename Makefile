VERSION = 1.0

tarball:
	mkdir -p postgrey-$(VERSION)
	./isgtc_to_public postgrey >postgrey-$(VERSION)/postgrey
	chmod +x postgrey-$(VERSION)/postgrey
	cp README postgrey-$(VERSION)/README
	cp postgrey_client_access postgrey-$(VERSION)
	[ -d pub ] || mkdir pub
	gtar czf pub/postgrey-$(VERSION).tar.gz postgrey-$(VERSION)
	rm -r postgrey-$(VERSION)
