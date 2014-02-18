indep_binaries := $(indep_binaries) gcc-source

p_source = gcc$(pkg_ver)-source
d_source= debian/$(p_source)

$(binary_stamp)-gcc-source:
	dh_testdir
	dh_testroot

	dh_install -p$(p_source) $(gcc_tarball) usr/src/gcc$(pkg_ver)
#	dh_install -p$(p_source) $(gcj_tarball) usr/src/gcc$(pkg_ver)
	dh_install -p$(p_source) debian/patches usr/src/gcc$(pkg_ver)
	chmod 755 debian/$(p_source)/usr/src/gcc$(pkg_ver)/patches/*.dpatch
	rm -rf debian/$(p_source)/usr/src/gcc$(pkg_ver)/patches/.svn
	dh_install -p$(p_source) \
	    debian/rules.source \
		usr/src/gcc$(pkg_ver)
	dh_install -p$(p_source) \
	    debian/rules.defs debian/rules.patch debian/rules.unpack \
	    debian/dummy.texi debian/gcc-dummy.texi debian/multiarch.inc \
	    debian/porting.* \
		usr/src/gcc$(pkg_ver)/debian

	debian/dh_doclink -p$(p_source) $(p_base)

	dh_fixperms -p$(p_source)
	dh_gencontrol -p$(p_source) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_source)
	dh_md5sums -p$(p_source)
	dh_builddeb -p$(p_source)

	touch $@
