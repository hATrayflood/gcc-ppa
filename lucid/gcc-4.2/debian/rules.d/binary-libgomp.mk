arch_binaries  := $(arch_binaries) libgomp
ifeq ($(with_lib64gomp),yes)
  arch_binaries  := $(arch_binaries) lib64gomp
endif
ifeq ($(with_lib32gomp),yes)
  arch_binaries	:= $(arch_binaries) lib32gomp
endif

p_gomp	= libgomp$(GOMP_SONAME)
p_l32gomp= lib32gomp$(GOMP_SONAME)
p_l64gomp= lib64gomp$(GOMP_SONAME)
p_gompdbg	= libgomp$(GOMP_SONAME)-dbg
p_l32gompdbg	= lib32gomp$(GOMP_SONAME)-dbg
p_l64gompdbg	= lib64gomp$(GOMP_SONAME)-dbg

d_gomp	= debian/$(p_gomp)
d_l32gomp= debian/$(p_l32gomp)
d_l64gomp= debian/$(p_l64gomp)
d_gompdbg	= debian/$(p_gompdbg)
d_l32gompdbg	= debian/$(p_l32gompdbg)
d_l64gompdbg	= debian/$(p_l64gompdbg)

dirs_gomp = \
	$(PF)/$(libdir)
files_gomp = \
	$(PF)/$(libdir)/libgomp.so.*

$(binary_stamp)-libgomp: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_gomp) $(d_gompdbg)
	dh_installdirs -p$(p_gomp) $(dirs_gomp)

	DH_COMPAT=2 dh_movefiles -p$(p_gomp) $(files_gomp)

	debian/dh_doclink -p$(p_gomp) $(p_base)
	debian/dh_doclink -p$(p_gompdbg) $(p_base)

	dh_strip -p$(p_gomp) --dbg-package=$(p_gompdbg)
	dh_compress -p$(p_gomp) -p$(p_gompdbg)
	dh_fixperms -p$(p_gomp) -p$(p_gompdbg)
	dh_makeshlibs -p$(p_gomp) -V '$(p_gomp) (>= $(DEB_GOMP_SOVERSION))'
	dh_shlibdeps -p$(p_gomp)
	dh_gencontrol -p$(p_gomp) -p$(p_gompdbg) \
		-- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_gomp) -p$(p_gompdbg)
	dh_md5sums -p$(p_gomp) -p$(p_gompdbg)
	dh_builddeb -p$(p_gomp) -p$(p_gompdbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-lib64gomp: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_l64gomp) $(d_l64gompdbg)
	dh_installdirs -p$(p_l64gomp) \
		$(PF)/lib64
	DH_COMPAT=2 dh_movefiles -p$(p_l64gomp) \
		$(PF)/lib64/libgomp.so.*

	debian/dh_doclink -p$(p_l64gomp) $(p_base)
	debian/dh_doclink -p$(p_l64gompdbg) $(p_base)

	dh_strip -p$(p_l64gomp) --dbg-package=$(p_l64gompdbg)
	dh_compress -p$(p_l64gomp) -p$(p_l64gompdbg)
	dh_fixperms -p$(p_l64gomp) -p$(p_l64gompdbg)
	dh_makeshlibs -p$(p_l64gomp) -V '$(p_l64gomp) (>= $(DEB_GOMP_SOVERSION))'
#	dh_shlibdeps -p$(p_l64gomp)
	dh_gencontrol -p$(p_l64gomp) -p$(p_l64gompdbg) \
		-- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_l64gomp) -p$(p_l64gompdbg)
	dh_md5sums -p$(p_l64gomp) -p$(p_l64gompdbg)
	dh_builddeb -p$(p_l64gomp) -p$(p_l64gompdbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-lib32gomp: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_l32gomp) $(d_l32gompdbg)
	dh_installdirs -p$(p_l32gomp) \
		$(lib32)
	DH_COMPAT=2 dh_movefiles -p$(p_l32gomp) \
		$(lib32)/libgomp.so.*

	debian/dh_doclink -p$(p_l32gomp) $(p_base)
	debian/dh_doclink -p$(p_l32gompdbg) $(p_base)

	dh_strip -p$(p_l32gomp) --dbg-package=$(p_l32gompdbg)
	dh_compress -p$(p_l32gomp) -p$(p_l32gompdbg)
	dh_fixperms -p$(p_l32gomp) -p$(p_l32gompdbg)
	dh_makeshlibs -p$(p_l32gomp) -V '$(p_l32gomp) (>= $(DEB_GOMP_SOVERSION))'
	dh_shlibdeps -p$(p_l32gomp)
	dh_gencontrol -p$(p_l32gomp) -p$(p_l32gompdbg) \
		-- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_l32gomp) -p$(p_l32gompdbg)
	dh_md5sums -p$(p_l32gomp) -p$(p_l32gompdbg)
	dh_builddeb -p$(p_l32gomp) -p$(p_l32gompdbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
