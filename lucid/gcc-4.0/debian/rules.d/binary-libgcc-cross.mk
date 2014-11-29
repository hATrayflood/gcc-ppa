ifeq ($(with_libgcc),yes)
  arch_binaries	:= $(arch_binaries) libgcc
endif
ifeq ($(with_lib64gcc),yes)
  arch_binaries	:= $(arch_binaries) lib64gcc
endif
ifeq ($(biarch32),yes)
  arch_binaries	:= $(arch_binaries) lib32gcc
endif

p_lgcc		= libgcc$(GCC_SONAME)$(cross_lib_arch)
d_lgcc		= debian/$(p_lgcc)

p_l64gcc	= lib32gcc$(GCC_SONAME)$(cross_lib_arch)
d_l64gcc	= debian/$(p_l32gcc)

p_l64gcc	= lib64gcc$(GCC_SONAME)$(cross_lib_arch)
d_l64gcc	= debian/$(p_l64gcc)

# ----------------------------------------------------------------------
$(binary_stamp)-libgcc: $(install_dependencies)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_lgcc)
	dh_installdirs -p$(p_lgcc) \
		$(docdir)/$(p_lgcc) \
		$(PF)/$(DEB_TARGET_GNU_TYPE)/lib

ifeq ($(with_shared_libgcc),yes)
	mv $(d)/$(PF)/$(DEB_TARGET_GNU_TYPE)/lib/libgcc_s.so.$(GCC_SONAME) $(d_lgcc)/$(PF)/$(DEB_TARGET_GNU_TYPE)/lib/.
endif

	dh_installdocs -p$(p_lgcc)
	dh_installchangelogs -p$(p_lgcc)

	debian/dh_rmemptydirs -p$(p_lgcc)
	PATH=/usr/share/dpkg-cross:$$PATH dh_strip -p$(p_lgcc)
	dh_compress -p$(p_lgcc)
	dh_fixperms -p$(p_lgcc)
ifeq ($(with_shared_libgcc),yes)
	dh_makeshlibs -p$(p_lgcc) -V '$(p_lgcc) (>= $(DEB_LIBGCC_SOVERSION))' -n
	sed s/$(cross_lib_arch)//g < debian/$(p_lgcc)/DEBIAN/shlibs > debian/$(p_lgcc)/DEBIAN/shlibs.fixed
	mv debian/$(p_lgcc)/DEBIAN/shlibs.fixed debian/$(p_lgcc)/DEBIAN/shlibs
	cat debian/$(p_lgcc)/DEBIAN/shlibs >> debian/shlibs.local
endif
	ARCH=$(DEB_TARGET_ARCH) MAKEFLAGS="CC=something" dh_shlibdeps -p$(p_lgcc)
	sed 's/\(lib[^ ]*\) /\1$(cross_lib_arch) /g' < debian/$(p_lgcc).substvars > debian/$(p_lgcc).substvars.new
	mv debian/$(p_lgcc).substvars.new debian/$(p_lgcc).substvars
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
		$(PF)/$(DEB_TARGET_GNU_TYPE)/lib64

ifeq ($(with_shared_libgcc),yes)
	mv $(d)/$(PF)/$(DEB_TARGET_GNU_TYPE)/lib64/libgcc_s.so.$(GCC_SONAME) $(d_l64gcc)/$(PF)/$(DEB_TARGET_GNU_TYPE)/lib64/.
endif

	dh_installdocs -p$(p_l64gcc)
	dh_installchangelogs -p$(p_l64gcc)

	debian/dh_rmemptydirs -p$(p_l64gcc)
	PATH=/usr/share/dpkg-cross:$$PATH dh_strip -p$(p_l64gcc)
	dh_compress -p$(p_l64gcc)
	dh_fixperms -p$(p_l64gcc)
ifeq ($(with_shared_libgcc),yes)
	dh_makeshlibs -p$(p_l64gcc) \
		-V '$(p_l64gcc) (>= $(DEB_LIBGCC_SOVERSION))' -n
	sed s/$(cross_lib_arch)//g < debian/$(p_l64gcc)/DEBIAN/shlibs > debian/$(p_l64gcc)/DEBIAN/shlibs.fixed
	mv debian/$(p_l64gcc)/DEBIAN/shlibs.fixed debian/$(p_l64gcc)/DEBIAN/shlibs
	cat debian/$(p_l64gcc)/DEBIAN/shlibs >> debian/shlibs.local
endif
	ARCH=$(DEB_TARGET_ARCH) MAKEFLAGS="CC=something" dh_shlibdeps -p$(p_l64gcc)
	sed 's/\(lib[^ ]*\) /\1$(cross_lib_arch) /g' < debian/$(p_l64gcc).substvars > debian/$(p_l64gcc).substvars.new
	mv debian/$(p_l64gcc).substvars.new debian/$(p_l64gcc).substvars
	dh_gencontrol -p$(p_l64gcc) \
		-- -v$(DEB_VERSION) $(common_substvars)
	b=libgcc; v=$(GCC_SONAME); \
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
		$(PF)/$(DEB_TARGET_GNU_TYPE)/lib32

ifeq ($(with_shared_libgcc),yes)
	mv $(d)/$(PF)/$(DEB_TARGET_GNU_TYPE)/lib32/libgcc_s.so.$(GCC_SONAME) $(d_l32gcc)/$(PF)/$(DEB_TARGET_GNU_TYPE)/lib32/.
endif

	dh_installdocs -p$(p_l32gcc)
	dh_installchangelogs -p$(p_l32gcc)

	debian/dh_rmemptydirs -p$(p_l32gcc)
	PATH=/usr/share/dpkg-cross:$$PATH dh_strip -p$(p_l32gcc)
	dh_compress -p$(p_l32gcc)
	dh_fixperms -p$(p_l32gcc)
ifeq ($(with_shared_libgcc),yes)
	dh_makeshlibs -p$(p_l32gcc) \
		-V '$(p_l32gcc) (>= $(DEB_LIBGCC_SOVERSION))' -n
	sed s/$(cross_lib_arch)//g < debian/$(p_l32gcc)/DEBIAN/shlibs > debian/$(p_l32gcc)/DEBIAN/shlibs.fixed
	mv debian/$(p_l32gcc)/DEBIAN/shlibs.fixed debian/$(p_l32gcc)/DEBIAN/shlibs
	cat debian/$(p_l32gcc)/DEBIAN/shlibs >> debian/shlibs.local
endif
	ARCH=$(DEB_TARGET_ARCH) MAKEFLAGS="CC=something" dh_shlibdeps -p$(p_l32gcc)
	sed 's/\(lib[^ ]*\) /\1$(cross_lib_arch) /g' < debian/$(p_l32gcc).substvars > debian/$(p_l32gcc).substvars.new
	mv debian/$(p_l32gcc).substvars.new debian/$(p_l32gcc).substvars
	dh_gencontrol -p$(p_l32gcc) \
		-- -v$(DEB_VERSION) $(common_substvars)
	b=libgcc; v=$(GCC_SONAME); \
	for ext in preinst postinst prerm postrm; do \
	  if [ -f debian/$$b$$t.$$ext ]; then \
	    cp -pf debian/$$b$$t.$$ext debian/$$b$$v$$t.$$ext; \
	  fi; \
	done
	dh_installdeb -p$(p_l32gcc)
	dh_md5sums -p$(p_l32gcc)
	dh_builddeb -p$(p_l32gcc)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
