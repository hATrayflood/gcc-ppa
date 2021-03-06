PPA = buildtest
BASE_URL = https://launchpad.net/ubuntu/+archive/primary/+files/
DISTRIBUTION = $(shell lsb_release -c | awk '{print $$2}')
ARCHITECTURE = $(shell dpkg --print-architecture)
RESULT_DIR   = ../../../pbuilder/$(DISTRIBUTION)-$(ARCHITECTURE)/result
REPREPRO_DIR = ../../../reprepro/$(DISTRIBUTION)-$(PPA)

all: debclean
	cd $(DIR) && debuild -uc -us

dput:
	rm -f *_source.changes
	cd $(DIR) && debuild -S  -sa
	@echo
	@echo dput ppa:h-rayflood/$(PPA) *_source.changes
	@echo

diff:
	if test -d debian ; then \
		echo $$(diff -urN debian $(DIR)/debian > debian.diff) ; \
	fi

install:
	dpkg -i $$(ls *_all.deb *_`dpkg --print-architecture`.deb 2>/dev/null)

clean:
	$(MAKE) -C $(DIR) -f debian/rules clean
	if test -f debian/README.Debian* ; then \
		cp -p debian/README.Debian* $(DIR)/debian ; \
	fi

debclean:
	rm -f *.deb
	rm -f $(DEL)

distclean: clean debclean
	rm -fr $(addprefix $(DIR)/,$(filter-out . .. debian,$(shell ls -a $(DIR))))

extract: $(SRC)
	for TAR in $(SRC) ; do \
		tar zxf $${TAR} ; \
	done

debian: $(DEB_DIFF)
	rm -fr $@
	gzip -cd $< | patch -p1

$(SRC) $(DEB_DIFF):
	wget $(BASE_URL)/$@

control:
	rm -f $(DIR)/debian/control
	$(MAKE) -C $(DIR) -f debian/rules control

resultclean:
	sudo rm -f $(RESULT_DIR)/*

pbuilder: resultclean debclean dput
	sudo pbuilder --build *.dsc

repolist:
	reprepro -b $(REPREPRO_DIR) list $(DISTRIBUTION)

reprepro:
ifeq ($(ARCHITECTURE),i386)
	reprepro -b $(REPREPRO_DIR) includedsc $(DISTRIBUTION) $(RESULT_DIR)/*.dsc
	reprepro -b $(REPREPRO_DIR) includedeb $(DISTRIBUTION) $(RESULT_DIR)/*_all.deb
endif
	reprepro -b $(REPREPRO_DIR) includedeb $(DISTRIBUTION) $(RESULT_DIR)/*_$(ARCHITECTURE).deb

.PHONY: all dput install extract debian clean debclean distclean control resultclean pbuilder repolist reprepro
.FORCE:
