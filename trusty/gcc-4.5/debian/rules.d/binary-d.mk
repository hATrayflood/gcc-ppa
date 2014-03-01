arch_binaries := $(arch_binaries) gdc

p_gdc		= gdc$(pkg_ver)
p_phobos	= libphobos

d_gdc		= debian/$(p_gdc)
d_phobos	= debian/$(p_phobos)


dirs_gdc = \
	$(PF)/bin \
	$(PF)/lib/gcc/$(DEB_HOST_GNU_TYPE)/$(BASE_VERSION) \
	$(PF)/share/man/man1

files_gdc = \
	$(PF)/bin/gdc$(pkg_ver) \
	$(PF)/bin/gdmd$(pkg_ver) \
	$(PF)/share/man/man1/gdc$(pkg_ver).1 \
	$(PF)/share/man/man1/gdmd$(pkg_ver).1 \
	$(PF)/lib/gcc/$(DEB_HOST_GNU_TYPE)/$(BASE_VERSION)/cc1d


dirs_phobos = \
	$(PF)/lib \
	$(PF)/include/d/$(BASE_VERSION)


files_phobos = \
	$(PF)/lib/libgphobos.a \
	$(PF)/include/d/$(BASE_VERSION)

dir_gdc += $(dirs_phobos)
files_gdc += $(files_phobos)

links_gdc = \
	/$(PF)/bin/gdc$(pkg_ver) /$(PF)/bin/gdc \
	/$(PF)/bin/gdmd$(pkg_ver) /$(PF)/bin/gdmd \

links_gdc += \
	/$(PF)/bin/gdc$(pkg_ver) /$(PF)/bin/$(DEB_TARGET_GNU_TYPE)-gdc$(pkg_ver) \
	/$(PF)/bin/gdc$(pkg_ver) /$(PF)/bin/$(DEB_TARGET_GNU_TYPE)-gdc \
	/$(PF)/bin/gdmd$(pkg_ver) /$(PF)/bin/$(DEB_TARGET_GNU_TYPE)-gdmd$(pkg_ver) \
	/$(PF)/bin/gdmd$(pkg_ver) /$(PF)/bin/$(DEB_TARGET_GNU_TYPE)-gdmd  \

links_gdc += \
	/$(PF)/share/man/man1/gdc$(pkg_ver).1 /$(PF)/share/man/man1/gdc.1 \
	/$(PF)/share/man/man1/gdmd$(pkg_ver).1 /$(PF)/share/man/man1/gdmd.1


$(binary_stamp)-gdc: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_gdc)
	dh_installdirs -p$(p_gdc) $(dirs_gdc)

	dh_installdocs -p$(p_gdc) \
		src/gcc/d/{README,GDC.html,History}
	dh_installchangelogs -p$(p_gdc) src/gcc/d/ChangeLog

	DH_COMPAT=2 dh_movefiles -p$(p_gdc) -X/zlib/ $(files_gdc)

	dh_link -p$(p_gdc) $(links_gdc)

	dh_link -p$(p_gdc) \
	    /$(PF)/include/d/$(BASE_VERSION) /$(PF)/include/d/$(GCC_VERSION)

	dh_strip -p$(p_gdc)
	dh_compress -p$(p_gdc)
	dh_fixperms -p$(p_gdc)
	dh_shlibdeps -p$(p_gdc)
	dh_gencontrol -p$(p_gdc) --  -v$(DEB_GDC_VERSION) $(common_substvars)
	dh_installdeb -p$(p_gdc)
	dh_md5sums -p$(p_gdc)
	dh_builddeb -p$(p_gdc)

	find $(d_gdc) -type d -empty -delete

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

$(binary_stamp)-phobos: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_phobos)
	dh_installdirs -p$(p_phobos) $(dirs_phobos)

	DH_COMPAT=2 dh_movefiles -p$(p_phobos) -X/zlib/ $(files_phobos)

	dh_link -p$(p_phobos) \
	    /$(PF)/include/d/$(BASE_VERSION) /$(PF)/include/d/$(GCC_VERSION)

	dh_strip -p$(p_phobos)
	dh_compress -p$(p_phobos)
	dh_fixperms -p$(p_phobos)
	dh_shlibdeps -p$(p_phobos)
	dh_gencontrol -p$(p_phobos) --  -v$(DEB_GDC_VERSION) $(common_substvars)
	dh_installdeb -p$(p_phobos)
	dh_md5sums -p$(p_phobos)
	dh_builddeb -p$(p_phobos)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

