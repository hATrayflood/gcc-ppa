ifeq ($(with_libgcc),yes)
  arch_binaries	:= $(arch_binaries) libgcc
endif
ifeq ($(with_lib32gcc),yes)
  arch_binaries	:= $(arch_binaries) lib32gcc
endif
ifeq ($(with_lib64gcc),yes)
  arch_binaries	:= $(arch_binaries) lib64gcc
endif

p_lgcc		= libgcc$(GCC_SONAME)
d_lgcc		= debian/$(p_lgcc)

p_l32gcc	= lib32gcc$(GCC_SONAME)
d_l32gcc	= debian/$(p_l32gcc)

p_l64gcc	= lib64gcc$(GCC_SONAME)
d_l64gcc	= debian/$(p_l64gcc)

# ----------------------------------------------------------------------
$(binary_stamp)-libgcc: $(install_dependencies)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_lgcc)
	dh_installdirs -p$(p_lgcc) \
		$(docdir)/$(p_lgcc) \
		$(libdir)

ifeq ($(with_shared_libgcc),yes)
	mv $(d)/$(PF)/lib/libgcc_s.so.$(GCC_SONAME) $(d_lgcc)/$(libdir)/.
endif

	dh_installdocs -p$(p_lgcc)
	dh_installchangelogs -p$(p_lgcc)

	debian/dh_rmemptydirs -p$(p_lgcc)
ifeq ($(with_shared_libgcc),yes)
	dh_makeshlibs -p$(p_lgcc) -V '$(p_lgcc) (>= $(DEB_LIBGCC_SOVERSION))'
	dh_shlibdeps -p$(p_lgcc)
	cat debian/$(p_lgcc)/DEBIAN/shlibs >> debian/shlibs.local
endif
	dh_strip -p$(p_lgcc)
	dh_compress -p$(p_lgcc)
	dh_fixperms -p$(p_lgcc)
	dh_gencontrol -p$(p_lgcc) \
		-- -v$(DEB_LIBGCC_VERSION) $(common_substvars)
	b=libgcc; v=$(GCC_SONAME); \
	for ext in preinst postinst prerm postrm; do \
	  if [ -f debian/$$b$$t.$$ext ]; then \
	    cp -pf debian/$$b$$t.$$ext debian/$$b$$v$$t.$$ext; \
	  fi; \
	done
	dh_installdeb -p$(p_lgcc)
	dh_md5sums -p$(p_lgcc)
	dh_builddeb -p$(p_lgcc)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-lib64gcc: $(install_dependencies)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_l64gcc)
	dh_installdirs -p$(p_l64gcc) \
		$(docdir)/$(p_l64gcc) \
		lib64

ifeq ($(with_shared_libgcc),yes)
	mv $(d)/$(PF)/lib64/libgcc_s.so.$(GCC_SONAME) $(d_l64gcc)/lib64/.
endif

	dh_installdocs -p$(p_l64gcc)
	dh_installchangelogs -p$(p_l64gcc)

	debian/dh_rmemptydirs -p$(p_l64gcc)
	dh_strip -p$(p_l64gcc)
	dh_compress -p$(p_l64gcc)
	dh_fixperms -p$(p_l64gcc)
ifeq ($(with_shared_libgcc),yes)
	dh_makeshlibs -p$(p_l64gcc) \
		-V '$(p_l64gcc) (>= $(DEB_LIBGCC_SOVERSION))'
# this does not work ... shlibs.local doesn't distinguish 32/64 bit libs
#	cat debian/$(p_l64gcc)/DEBIAN/shlibs >> debian/shlibs.local
endif
ifeq ($(DEB_TARGET_ARCH),s390)
#	dh_shlibdeps -p$(p_l64gcc)
#/usr/bin/ldd: line 1: /lib/ld64.so.1: cannot execute binary file
#dpkg-shlibdeps: failure: ldd on `debian/lib64gcc1/lib64/libgcc_s.so.1' gave error exit status 1
	echo 'shlibs:Depends=libc6-s390x (>= 2.3.1-1)' \
		> debian/$(p_l64gcc).substvars
else
  ifeq ($(DEB_TARGET_ARCH),i386)
	echo 'shlibs:Depends=libc6-amd64' \
		> debian/$(p_l64gcc).substvars
  else
    ifeq ($(DEB_TARGET_ARCH),powerpc)
	echo 'shlibs:Depends=libc6-ppc64' \
		> debian/$(p_l64gcc).substvars
    else
      ifeq ($(DEB_TARGET_ARCH),sparc)
	echo 'shlibs:Depends=libc6-sparc64' \
		> debian/$(p_l64gcc).substvars
      else
	dh_shlibdeps -p$(p_l64gcc)
      endif
    endif
  endif
endif
	dh_gencontrol -p$(p_l64gcc) \
		-- -v$(DEB_LIBGCC_VERSION) $(common_substvars)
	b=lib64gcc; v=$(GCC_SONAME); \
	for ext in preinst postinst prerm postrm; do \
	  if [ -f debian/$$b$$t.$$ext ]; then \
	    cp -pf debian/$$b$$t.$$ext debian/$$b$$v$$t.$$ext; \
	  fi; \
	done
	dh_installdeb -p$(p_l64gcc)
	dh_md5sums -p$(p_l64gcc)
	dh_builddeb -p$(p_l64gcc)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------

$(binary_stamp)-lib32gcc: $(install_dependencies)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_l32gcc)
	dh_installdirs -p$(p_l32gcc) \
		$(docdir)/$(p_l32gcc) \
		$(lib32)
	mv $(d)/$(PF)/lib32/libgcc_s.so.$(GCC_SONAME) \
		$(d_l32gcc)/$(lib32)/.

	dh_installdocs -p$(p_l32gcc)
	dh_installchangelogs -p$(p_l32gcc)

	debian/dh_rmemptydirs -p$(p_l32gcc)
	dh_strip -p$(p_l32gcc)
	dh_compress -p$(p_l32gcc)
	dh_fixperms -p$(p_l32gcc)
	dh_gencontrol -p$(p_l32gcc) \
		-- -v$(DEB_VERSION) $(common_substvars)
	b=lib32gcc; v=$(GCC_SONAME); \
	for ext in preinst postinst prerm postrm; do \
	  if [ -f debian/$$b$$t.$$ext ]; then \
	    cp -pf debian/$$b$$t.$$ext debian/$$b$$v$$t.$$ext; \
	  fi; \
	done
	dh_installdeb -p$(p_l32gcc)
	dh_md5sums -p$(p_l32gcc)
	dh_builddeb -p$(p_l32gcc)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
