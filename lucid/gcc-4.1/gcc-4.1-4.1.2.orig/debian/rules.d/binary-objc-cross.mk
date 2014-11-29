arch_binaries := $(arch_binaries) objc

p_objc	= gobjc$(pkg_ver)$(cross_bin_arch)
d_objc	= debian/$(p_objc)

dirs_objc = \
	$(docdir) \
	$(gcc_lib_dir)

files_objc = \
	$(gcc_lib_dir)/cc1obj \
	$(gcc_lib_dir)/include/objc \
	$(gcc_lib_dir)/{libobjc*.a,libobjc*.la}

$(binary_stamp)-objc: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	mv $(d)/$(PF)/$(DEB_TARGET_GNU_TYPE)/$(libdir)/libobjc*.{a,la} $(d)/$(gcc_lib_dir)/

	rm -rf $(d_objc)
	dh_installdirs -p$(p_objc) $(dirs_objc)
	DH_COMPAT=2 dh_movefiles -p$(p_objc) $(files_objc)

ifeq ($(with_lib64objc),yes)
	mkdir -p $(d_objc)/$(gcc_lib_dir)/$(biarchsubdir)
	mv $(d)/$(PF)/$(DEB_TARGET_GNU_TYPE)/lib64/libobjc*.{a,la} $(d_objc)/$(gcc_lib_dir)/$(biarchsubdir)/
	dh_link -p$(p_objc) \
	  /$(PF)/$(DEB_TARGET_GNU_TYPE)/lib64/libobjc.so.$(OBJC_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libobjc.so
endif
ifeq ($(with_lib32objc),yes)
	mkdir -p $(d_objc)/$(gcc_lib_dir)/$(biarchsubdir)
	mv $(d)/$(DEB_TARGET_GNU_TYPE)/$(lib32)/libobjc*.{a,la} $(d_objc)/$(gcc_lib_dir)/$(biarchsubdir)/
	dh_link -p$(p_objc) \
	  /$(lib32)/$(DEB_TARGET_GNU_TYPE)/libobjc.so.$(OBJC_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libobjc.so
endif

	dh_link -p$(p_objc) \
	  /$(PF)/$(DEB_TARGET_GNU_TYPE)/$(libdir)/libobjc.so.$(OBJC_SONAME) /$(gcc_lib_dir)/libobjc.so
ifeq ($(with_objc_gc),yes)
	dh_link -p$(p_objc) \
	  /$(PF)/$(DEB_TARGET_GNU_TYPE)/$(libdir)/libobjc_gc.so.$(OBJC_SONAME) \
	  /$(gcc_lib_dir)/libobjc_gc.so
endif

	debian/dh_doclink -p$(p_objc) $(p_base)
	debian/dh_rmemptydirs -p$(p_objc)

	dh_strip -p$(p_objc)
	dh_compress -p$(p_objc)

	dh_fixperms -p$(p_objc)
	dh_shlibdeps -p$(p_objc)
	dh_gencontrol -p$(p_objc) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_objc)
	dh_md5sums -p$(p_objc)
	dh_builddeb -p$(p_objc)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
