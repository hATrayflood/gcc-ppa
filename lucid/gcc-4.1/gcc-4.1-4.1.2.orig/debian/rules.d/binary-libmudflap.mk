ifeq ($(with_dev),yes)
  arch_binaries  := $(arch_binaries) libmudflapdev
endif

ifeq ($(with_libmudflap),yes)
  arch_binaries  := $(arch_binaries) libmudflap
  ifeq ($(with_lib64mudflap),yes)
    arch_binaries  := $(arch_binaries) lib64mudflap
  endif
  ifeq ($(with_lib32mudflap),yes)
    arch_binaries	:= $(arch_binaries) lib32mudflap
  endif
endif

p_mf	= libmudflap$(MUDFLAP_SONAME)
p_l32mf	= lib32mudflap$(MUDFLAP_SONAME)
p_l64mf	= lib64mudflap$(MUDFLAP_SONAME)
p_mfd	= libmudflap$(MUDFLAP_SONAME)-dev

d_mf	= debian/$(p_mf)
d_l32mf	= debian/$(p_l32mf)
d_l64mf	= debian/$(p_l64mf)
d_mfd	= debian/$(p_mfd)

dirs_mfd = \
	$(docdir)/$(p_base)/mudflap \
	$(PF)/include \
	$(PF)/$(libdir)
files_mfd = \
	$(PF)/include/mf-runtime.h \
	$(PF)/$(libdir)/libmudflap*.{a,so,la}

ifeq ($(with_lib32mudflap),yes)
	dirs_mfd  += $(lib32)
	files_mfd += $(lib32)/libmudflap*.{a,so,la}
endif
ifeq ($(with_lib64mudflap),yes)
	dirs_mfd  += $(PF)/lib64
	files_mfd += $(PF)/lib64/libmudflap*.{a,so,la}
endif

$(binary_stamp)-libmudflap: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_mf)
	dh_installdirs -p$(p_mf) \
		$(docdir) \
		$(PF)/$(libdir)

	DH_COMPAT=2 dh_movefiles -p$(p_mf) \
		$(PF)/$(libdir)/libmudflap*.so.*

	debian/dh_doclink -p$(p_mf) $(p_base)
	debian/dh_rmemptydirs -p$(p_mf)
	dh_strip -p$(p_mf)
	dh_compress -p$(p_mf)
	dh_fixperms -p$(p_mf)
	dh_makeshlibs -p$(p_mf) -V '$(p_mf) (>= $(DEB_SOVERSION))'
	dh_shlibdeps -p$(p_mf)
	dh_gencontrol -p$(p_mf) \
		-- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_mf)
	dh_md5sums -p$(p_mf)
	dh_builddeb -p$(p_mf)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-libmudflapdev: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_mfd)
	dh_installdirs -p$(p_mfd) $(dirs_mfd)

	rm -f $(d)/$(PF)/$(libdir)/libmudflap*.so
	mv $(d)/$(PF)/$(libdir)/libmudflap*.a $(d)/$(gcc_lib_dir)/

	rm -f $(d)/$(PF)/$(libdir)/libmudflap*.la
	rm -f $(d)/$(PF)/$(libdir)/$(biarchsubdir)/libmudflap*.la

	DH_COMPAT=2 dh_movefiles -p$(p_mfd) $(files_mfd)

	dh_link -p$(p_mfd) \
	  /$(PF)/$(libdir)/libmudflap.so.$(MUDFLAP_SONAME) /$(gcc_lib_dir)/libmudflap.so \
	  /$(PF)/$(libdir)/libmudflapth.so.$(MUDFLAP_SONAME) /$(gcc_lib_dir)/libmudflapth.so

ifeq ($(with_lib32mudflap),yes)
	rm -f $(d)/$(lib32)/libmudflap*.so
	mkdir -p $(d_mfd)/$(gcc_lib_dir)/$(biarchsubdir)
	mv $(d)/$(lib32)/libmudflap*.a $(d_mfd)/$(gcc_lib_dir)/$(biarchsubdir)/
	dh_link -p$(p_mfd) \
	  /$(lib32)/libmudflap.so.$(MUDLFLAP_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libmudflap.so \
	  /$(lib32)/libmudflapth.so.$(MUDFLAP_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libmudflapth.so
endif

ifeq ($(with_lib64mudflap),yes)
	rm -f $(d)/$(PF)/$(lib64)/libmudflap*.so
	mkdir -p $(d_mfd)/$(gcc_lib_dir)/$(biarchsubdir)
	mv $(d)/$(PF)/$(lib64)/libmudflap*.a $(d_mfd)/$(gcc_lib_dir)/$(biarchsubdir)/
	dh_link -p$(p_mfd) \
	  /$(PF)/lib64/libmudflap.so.$(MUDLFLAP_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libmudflap.so \
	  /$(PF)/lib64/libmudflapth.so.$(MUDFLAP_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libmudflapth.so
endif

	cp -p $(srcdir)/libmudflap/ChangeLog \
		$(d_mfd)/$(docdir)/$(p_base)/mudflap/changelog

	debian/dh_doclink -p$(p_mfd) $(p_base)
	debian/dh_rmemptydirs -p$(p_mfd)

	dh_strip -p$(p_mfd)
	dh_compress -p$(p_mfd)
	dh_fixperms -p$(p_mfd)
	dh_shlibdeps -p$(p_mfd)
	dh_gencontrol -p$(p_mfd) \
		-- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_mfd)
	dh_md5sums -p$(p_mfd)
	dh_builddeb -p$(p_mfd)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-lib64mudflap: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_l64mf)
	dh_installdirs -p$(p_l64mf) \
		$(PF)/lib64
	DH_COMPAT=2 dh_movefiles -p$(p_l64mf) \
		$(PF)/lib64/libmudflap*.so.*

	debian/dh_doclink -p$(p_l64mf) $(p_base)

	dh_strip -p$(p_l64mf)
	dh_compress -p$(p_l64mf)
	dh_fixperms -p$(p_l64mf)
	dh_makeshlibs -p$(p_l64mf) -V '$(p_l64mf) (>= $(DEB_SOVERSION))'
#	dh_shlibdeps -p$(p_l64mf)
	dh_gencontrol -p$(p_l64mf) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_l64mf)
	dh_md5sums -p$(p_l64mf)
	dh_builddeb -p$(p_l64mf)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-lib32mudflap: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_l32mf)
	dh_installdirs -p$(p_l32mf) \
		$(lib32)
	DH_COMPAT=2 dh_movefiles -p$(p_l32mf) \
		$(lib32)/libmudflap*.so.*

	debian/dh_doclink -p$(p_l32mf) $(p_base)

	dh_strip -p$(p_l32mf)
	dh_compress -p$(p_l32mf)
	dh_fixperms -p$(p_l32mf)
	dh_makeshlibs -p$(p_l32mf) -V '$(p_l32mf) (>= $(DEB_SOVERSION))'
#	dh_shlibdeps -p$(p_l32mf)
	dh_gencontrol -p$(p_l32mf) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_l32mf)
	dh_md5sums -p$(p_l32mf)
	dh_builddeb -p$(p_l32mf)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
