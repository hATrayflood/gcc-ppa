ifeq ($(with_libgcc),yes)
  arch_binaries	:= $(arch_binaries) libgcc
endif
ifeq ($(with_lib64gcc),yes)
  arch_binaries	:= $(arch_binaries) lib64gcc
endif
ifeq ($(biarch32),yes)
  arch_binaries	:= $(arch_binaries) lib32gcc
endif

p_lgcc		= libgcc$(GCC_SONAME)
p_lgccdbg	= libgcc$(GCC_SONAME)-dbg
d_lgcc		= debian/$(p_lgcc)
d_lgccdbg	= debian/$(p_lgccdbg)

p_l32gcc	= lib32gcc$(GCC_SONAME)
p_l32gccdbg	= lib32gcc$(GCC_SONAME)-dbg
d_l32gcc	= debian/$(p_l32gcc)
d_l32gccdbg	= debian/$(p_l32gccdbg)

p_l64gcc	= lib64gcc$(GCC_SONAME)
p_l64gccdbg	= lib64gcc$(GCC_SONAME)-dbg
d_l64gcc	= debian/$(p_l64gcc)
d_l64gccdbg	= debian/$(p_l64gccdbg)

# ----------------------------------------------------------------------
$(binary_stamp)-libgcc: $(install_dependencies)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_lgcc) $(d_lgccdbg)
	dh_installdirs -p$(p_lgcc) \
		$(docdir)/$(p_lgcc) \
		$(libdir)

ifeq ($(with_shared_libgcc),yes)
	mv $(d)/$(PF)/lib/libgcc_s.so.$(GCC_SONAME) $(d_lgcc)/$(libdir)/.
endif

ifeq ($(with_standalone_gcj),yes)
	debian/dh_doclink -p$(p_lgcc) $(p_jbase)
	debian/dh_doclink -p$(p_lgccdbg) $(p_jbase)
else
	debian/dh_doclink -p$(p_lgcc) $(p_base)
	debian/dh_doclink -p$(p_lgccdbg) $(p_base)
endif
	debian/dh_rmemptydirs -p$(p_lgcc)
	debian/dh_rmemptydirs -p$(p_lgccdbg)
	dh_strip -v -p$(p_lgcc) --dbg-package=$(p_lgccdbg)
	dh_compress -p$(p_lgcc) -p$(p_lgccdbg)
	dh_fixperms -p$(p_lgcc) -p$(p_lgccdbg)
ifeq ($(with_shared_libgcc),yes)
	dh_makeshlibs -p$(p_lgcc) -V '$(p_lgcc) (>= $(DEB_LIBGCC_SOVERSION))' \
		-- -v$(DEB_LIBGCC_VERSION)
	cat debian/$(p_lgcc)/DEBIAN/shlibs >> debian/shlibs.local
endif
	dh_shlibdeps -p$(p_lgcc)
	dh_gencontrol -p$(p_lgcc) -p$(p_lgccdbg) \
		-- -v$(DEB_LIBGCC_VERSION) $(common_substvars)

	mkdir -p $(d_lgcc)/usr/share/lintian/overrides
	echo '$(p_lgcc): package-name-doesnt-match-sonames' \
		> $(d_lgcc)/usr/share/lintian/overrides/$(p_lgcc)

	dh_installdeb -p$(p_lgcc) -p$(p_lgccdbg)
	dh_md5sums -p$(p_lgcc) -p$(p_lgccdbg)
	dh_builddeb -p$(p_lgcc) -p$(p_lgccdbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-lib64gcc: $(install_dependencies)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_l64gcc) $(d_l64gccdbg)
	dh_installdirs -p$(p_l64gcc) \
		$(docdir)/$(p_l64gcc) \
		lib64

ifeq ($(with_shared_libgcc),yes)
	mv $(d)/$(PF)/lib64/libgcc_s.so.$(GCC_SONAME) $(d_l64gcc)/lib64/.
endif

	debian/dh_doclink -p$(p_l64gcc) $(p_base)
	debian/dh_doclink -p$(p_l64gccdbg) $(p_base)
	debian/dh_rmemptydirs -p$(p_l64gcc)
	debian/dh_rmemptydirs -p$(p_l64gccdbg)
	dh_strip -p$(p_l64gcc) --dbg-package=$(p_l64gccdbg)
	dh_compress -p$(p_l64gcc) -p$(p_l64gccdbg)
	dh_fixperms -p$(p_l64gcc) -p$(p_l64gccdbg)
ifeq ($(with_shared_libgcc),yes)
	dh_makeshlibs -p$(p_l64gcc) \
		-V '$(p_l64gcc) (>= $(DEB_LIBGCC_SOVERSION))' \
		-- -v$(DEB_LIBGCC_VERSION)
# this does not work ... shlibs.local doesn't distinguish 32/64 bit libs
#	cat debian/$(p_l64gcc)/DEBIAN/shlibs >> debian/shlibs.local
endif
#	dh_shlibdeps -p$(p_l64gcc)
#/usr/bin/ldd: line 1: /lib/ld64.so.1: cannot execute binary file
#dpkg-shlibdeps: failure: ldd on `debian/lib64gcc1/lib64/libgcc_s.so.1' gave error exit status 1
ifeq ($(DEB_TARGET_ARCH),s390)
	echo 'shlibs:Depends=libc6-s390x (>= 2.3.1-1)' \
		> debian/$(p_l64gcc).substvars
endif
ifeq ($(DEB_TARGET_ARCH),i386)
	echo 'shlibs:Depends=libc6-amd64' \
		> debian/$(p_l64gcc).substvars
endif
ifeq ($(DEB_TARGET_ARCH),sparc)
	echo 'shlibs:Depends=libc6-sparc64 (>= 2.3.1-1)' \
		> debian/$(p_l64gcc).substvars
endif
ifeq ($(DEB_TARGET_ARCH),powerpc)
	# FIXME change dependency when lib64c6 exists
	echo 'shlibs:Depends=libc6 (>= 0.1)' \
		> debian/$(p_l64gcc).substvars
endif
	dh_gencontrol -p$(p_l64gcc) -p$(p_l64gccdbg) \
		-- -v$(DEB_LIBGCC_VERSION) $(common_substvars)
	dh_installdeb -p$(p_l64gcc) -p$(p_l64gccdbg)
	dh_md5sums -p$(p_l64gcc) -p$(p_l64gccdbg)
	dh_builddeb -p$(p_l64gcc) -p$(p_l64gccdbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------

$(binary_stamp)-lib32gcc: $(install_dependencies)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_l32gcc) $(d_l32gccdbg)

	dh_installdirs -p$(p_l32gcc) \
		$(docdir)/$(p_l32gcc) \
		$(lib32)
	mv $(d)/$(lib32)/libgcc_s.so.$(GCC_SONAME) \
		$(d_l32gcc)/$(lib32)/.

	debian/dh_doclink -p$(p_l32gcc) $(p_base)
	debian/dh_doclink -p$(p_l32gccdbg) $(p_base)
	debian/dh_rmemptydirs -p$(p_l32gcc)
	debian/dh_rmemptydirs -p$(p_l32gccdbg)
	dh_strip -p$(p_l32gcc) --dbg-package=$(p_l32gccdbg)

	dh_makeshlibs -p$(p_l32gcc) -p$(p_l32gccdbg) \
		-V '$(p_l32gcc) (>= $(DEB_LIBGCC_SOVERSION))' \
		-- -v$(DEB_LIBGCC_VERSION)
ifeq ($(DEB_TARGET_ARCH),amd64)
	echo 'shlibs:Depends=libc6-i386 | ia32-libs' \
		> debian/$(p_l32gcc).substvars
endif
ifeq ($(DEB_TARGET_ARCH),ppc64)
	echo 'shlibs:Depends=libc6-powerpc' \
		> debian/$(p_l32gcc).substvars
endif

	dh_compress -p$(p_l32gcc) -p$(p_l32gccdbg)
	dh_fixperms -p$(p_l32gcc) -p$(p_l32gccdbg)
	dh_gencontrol -p$(p_l32gcc) -p$(p_l32gccdbg) \
		-- -v$(DEB_LIBGCC_VERSION) $(common_substvars)
ifeq (,$(findstring emul, $(lib32)))
	rm -f debian/lib32gcc1.preinst
endif
	dh_installdeb -p$(p_l32gcc) -p$(p_l32gccdbg)
	dh_md5sums -p$(p_l32gcc) -p$(p_l32gccdbg)
	dh_builddeb -p$(p_l32gcc) -p$(p_l32gccdbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
