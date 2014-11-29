arch_binaries := $(arch_binaries) gdc

ifeq ($(with_libphobos),yes)
  arch_binaries += libphobos
endif

p_gdc		= gdc$(pkg_ver)
d_gdc		= debian/$(p_gdc)

# no shared lib for now
p_libphobos	= libphobos$(libphobos_version)$(pkg_ver)-dev
d_libphobos	= debian/$(p_libphobos)

gdc_include_dir := $(PF)/include/d$(libphobos_version)

dirs_gdc = \
	$(PF)/bin \
	$(PF)/share/man/man1 \
	$(gdc_include_dir)/$(BASE_VERSION) \
	$(gcc_lib_dir)

files_gdc = \
	$(PF)/bin/gdc$(pkg_ver) \
	$(PF)/bin/gdmd$(pkg_ver) \
	$(PF)/share/man/man1/gdc$(pkg_ver).1 \
	$(PF)/share/man/man1/gdmd$(pkg_ver).1 \
	$(gcc_lib_dir)/cc1d


dirs_libphobos = \
	$(PF)/lib \
	$(gdc_include_dir)/$(BASE_VERSION) \
	$(gcc_lib_dir)

files_libphobos = \
	$(PF)/lib/libgphobos$(libphobos_version).a \
	$(gdc_include_dir)/$(BASE_VERSION)


# include path
links_gdc = \
	/$(gdc_include_dir)/$(BASE_VERSION) \
		/$(gdc_include_dir)/$(GCC_VERSION)


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

	# Always needed by gdc.
	cp $(srcdir)/gcc/d/phobos$(libphobos_version)/object.d \
		$(d_gdc)/$(gdc_include_dir)/$(BASE_VERSION)/

	dh_link -p$(p_gdc) $(links_gdc)

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

$(binary_stamp)-libphobos: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_libphobos)
	dh_installdirs -p$(p_libphobos) $(dirs_libphobos)

	DH_COMPAT=2 dh_movefiles -p$(p_libphobos) -X/zlib/ $(files_libphobos)

        # better to have it there, avoid conflicts
	mv $(d_libphobos)/$(PF)/lib/libgphobos$(libphobos_version).a \
		$(d_libphobos)/$(gcc_lib_dir)

	# included in gdc package
	rm -f $(d_libphobos)/$(gdc_include_dir)/$(BASE_VERSION)/object.d

	# no need to have it twice
	dh_link -p$(p_libphobos) \
		/$(PF)/share/doc/$(p_gdc) /$(PF)/share/doc/$(p_libphobos)

	dh_strip -p$(p_libphobos)
	dh_compress -p$(p_libphobos)
	dh_fixperms -p$(p_libphobos)
	dh_shlibdeps -p$(p_libphobos)
	dh_gencontrol -p$(p_libphobos) --  -v$(DEB_GDC_VERSION) $(common_substvars)
	dh_installdeb -p$(p_libphobos)
	dh_md5sums -p$(p_libphobos)
	dh_builddeb -p$(p_libphobos)

	find $(d_libphobos) -type d -empty -delete

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

