ifeq ($(with_objcdev),yes)
  arch_binaries := $(arch_binaries) libobjc
endif
ifeq ($(with_lib64objc),yes)
  arch_binaries  := $(arch_binaries) lib64objc
endif
ifeq ($(with_lib32objc),yes)
  arch_binaries	:= $(arch_binaries) lib32objc
endif

p_lobjc		= libobjc$(OBJC_SONAME)
p_l32objc	= lib32objc$(OBJC_SONAME)
p_l64objc	= lib64objc$(OBJC_SONAME)
p_lobjcdbg	= libobjc$(OBJC_SONAME)-dbg
p_l32objcdbg	= lib32objc$(OBJC_SONAME)-dbg
p_l64objcdbg	= lib64objc$(OBJC_SONAME)-dbg

d_lobjc		= debian/$(p_lobjc)
d_l32objc	= debian/$(p_l32objc)
d_l64objc	= debian/$(p_l64objc)
d_lobjcdbg	= debian/$(p_lobjcdbg)
d_l32objcdbg	= debian/$(p_l32objcdbg)
d_l64objcdbg	= debian/$(p_l64objcdbg)

dirs_lobjc = \
	$(docdir)/objc \
	$(PF)/$(libdir)
files_lobjc = \
	$(PF)/$(libdir)/libobjc.so.*
ifeq ($(with_objc_gc),yes)
  files_lobjc += \
	$(PF)/$(libdir)/libobjc_gc.so.*
endif


$(binary_stamp)-libobjc: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_lobjc) $(d_lobjcdbg)
	dh_installdirs -p$(p_lobjc) $(dirs_lobjc)
#	mv $(d)/$(gcc_lib_dir)/libobjc.so.* $(d)/$(PF)/$(libdir)/.
#ifeq ($(with_objc_gc),yes)
#	mv $(d)/$(gcc_lib_dir)/libobjc_gc.so.* $(d)/$(PF)/$(libdir)/.
#endif
	DH_COMPAT=2 dh_movefiles -p$(p_lobjc) $(files_lobjc)

	debian/dh_doclink -p$(p_lobjc) $(p_base)
	debian/dh_doclink -p$(p_lobjcdbg) $(p_base)

	debian/dh_rmemptydirs -p$(p_lobjc)

	dh_strip -p$(p_lobjc) --dbg-package=$(p_lobjcdbg)
	dh_compress -p$(p_lobjc) -p$(p_lobjcdbg)

	dh_fixperms -p$(p_lobjc) -p$(p_lobjcdbg)
	b=libobjc; \
	for ext in preinst postinst prerm postrm; do \
	  for t in '' -dev -dbg; do \
	    v=$(OBJC_SONAME); \
	    if [ -f debian/$$b$$t.$$ext ]; then \
	      cp -pf debian/$$b$$t.$$ext debian/$$b$$v$$t.$$ext; \
	    fi; \
	  done; \
	done
	dh_makeshlibs -p$(p_lobjc) -V '$(p_lobjc) (>= $(DEB_SOVERSION))'
	dh_shlibdeps -p$(p_lobjc)
	dh_gencontrol -p$(p_lobjc) -p$(p_lobjcdbg) \
		-- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_lobjc) -p$(p_lobjcdbg)
	dh_md5sums -p$(p_lobjc) -p$(p_lobjcdbg)
	dh_builddeb -p$(p_lobjc) -p$(p_lobjcdbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-lib64objc: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_l64objc) $(d_l64objcdbg)
	dh_installdirs -p$(p_l64objc) \
		$(PF)/lib64
	DH_COMPAT=2 dh_movefiles -p$(p_l64objc) \
		$(PF)/lib64/libobjc.so.*
ifeq ($(with_objc_gc),yes)
	DH_COMPAT=2 dh_movefiles -p$(p_l64objc) \
		$(PF)/lib64/libobjc_gc.so.*
endif
	debian/dh_doclink -p$(p_l64objc) $(p_base)
	debian/dh_doclink -p$(p_l64objcdbg) $(p_base)

	dh_strip -p$(p_l64objc) --dbg-package=$(p_l64objcdbg)
	dh_compress -p$(p_l64objc) -p$(p_l64objcdbg)
	dh_fixperms -p$(p_l64objc) -p$(p_l64objcdbg)
	dh_makeshlibs -p$(p_l64objc) -V '$(p_l64objc) (>= $(DEB_SOVERSION))'
#	dh_shlibdeps -p$(p_l64objc)
	dh_gencontrol -p$(p_l64objc) -p$(p_l64objcdbg) \
		-- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_l64objc) -p$(p_l64objcdbg)
	dh_md5sums -p$(p_l64objc) -p$(p_l64objcdbg)
	dh_builddeb -p$(p_l64objc) -p$(p_l64objcdbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-lib32objc: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_l32objc) $(d_l32objcdbg)
	dh_installdirs -p$(p_l32objc) \
		$(lib32)
	DH_COMPAT=2 dh_movefiles -p$(p_l32objc) \
		$(lib32)/libobjc.so.*
ifeq ($(with_objc_gc),yes)
	DH_COMPAT=2 dh_movefiles -p$(p_l32objc) \
		$(lib32)/libobjc_gc.so.*
endif
	debian/dh_doclink -p$(p_l32objc) $(p_base)
	debian/dh_doclink -p$(p_l32objcdbg) $(p_base)

	dh_strip -p$(p_l32objc) --dbg-package=$(p_l32objcdbg)
	dh_compress -p$(p_l32objc) -p$(p_l32objcdbg)
	dh_fixperms -p$(p_l32objc) -p$(p_l32objcdbg)
	dh_makeshlibs -p$(p_l32objc) -V '$(p_l32objc) (>= $(DEB_SOVERSION))'
#	dh_shlibdeps -p$(p_l32objc)
	dh_gencontrol -p$(p_l32objc) -p$(p_l32objcdbg) \
		-- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_l32objc) -p$(p_l32objcdbg)
	dh_md5sums -p$(p_l32objc) -p$(p_l32objcdbg)
	dh_builddeb -p$(p_l32objc) -p$(p_l32objcdbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
