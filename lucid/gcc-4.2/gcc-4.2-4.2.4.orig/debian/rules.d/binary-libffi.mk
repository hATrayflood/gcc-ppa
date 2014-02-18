arch_binaries  := $(arch_binaries) libffi
ifeq ($(with_lib64ffi),yes)
  arch_binaries  := $(arch_binaries) lib64ffi
endif
ifeq ($(with_lib32ffi),yes)
  arch_binaries	:= $(arch_binaries) lib32ffi
endif

p_ffi	= libffi$(FFI_SONAME)
p_l32ffi= lib32ffi$(FFI_SONAME)
p_l64ffi= lib64ffi$(FFI_SONAME)
p_ffid	= libffi$(FFI_SONAME)-dev
p_ffidbg	= libffi$(FFI_SONAME)-dbg
p_l32ffidbg	= lib32ffi$(FFI_SONAME)-dbg
p_l64ffidbg	= lib64ffi$(FFI_SONAME)-dbg

d_ffi	= debian/$(p_ffi)
d_l32ffi= debian/$(p_l32ffi)
d_l64ffi= debian/$(p_l64ffi)
d_ffid	= debian/$(p_ffid)
d_ffidbg	= debian/$(p_ffidbg)
d_l32ffidbg	= debian/$(p_l32ffidbg)
d_l64ffidbg	= debian/$(p_l64ffidbg)

dirs_ffi = \
	$(docdir)/$(p_base)/libffi \
	$(PF)/$(libdir)
files_ffi = \
	$(PF)/$(libdir)/libffi.so.*

dirs_ffid = \
	$(docdir)/$(p_base)/libffi \
	$(PF)/include \
	$(gcc_lib_dir)/include
files_ffid = \
	$(PF)/include/{ffi.h,ffitarget.h} \
	$(PF)/$(libdir)/libffi.{a,so}

ifeq ($(with_lib32ffi),yes)
	dirs_ffid  += $(lib32)
	files_ffid += $(lib32)/libffi.{a,so}
endif
ifeq ($(with_lib64ffi),yes)
	dirs_ffid  += $(PF)/lib64
	files_ffid += $(PF)/lib64/libffi.{a,so}
endif

$(binary_stamp)-libffi: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_ffi) $(d_ffid) $(d_ffidbg)
	dh_installdirs -p$(p_ffi) $(dirs_ffi)
	dh_installdirs -p$(p_ffid) $(dirs_ffid)

	mv $(d)/$(gcc_lib_dir)/include/ffi*.h $(d)/$(PF)/include/.

	DH_COMPAT=2 dh_movefiles -p$(p_ffi) $(files_ffi)
	DH_COMPAT=2 dh_movefiles -p$(p_ffid) $(files_ffid)

	cp -p $(buildlibdir)/libffi/.libs/libffi_convenience.a \
		$(d_ffid)/$(PF)/lib/libffi_pic.a

ifeq ($(with_lib64ffi),yes)
	cp -p $(buildlibdir)/64/libffi/.libs/libffi_convenience.a \
		$(d_ffid)/$(PF)/$(lib64)/libffi_pic.a
endif
ifeq ($(with_lib32ffi),yes)
	cp -p $(buildlibdir)/32/libffi/.libs/libffi_convenience.a \
		$(d_ffid)/$(lib32)/libffi_pic.a
endif

	cp -p $(srcdir)/libffi/README $(d_ffid)/$(docdir)/$(p_base)/libffi/
	cp -p $(srcdir)/libffi/ChangeLog \
		$(d_ffid)/$(docdir)/$(p_base)/libffi/changelog
	cp -p $(srcdir)/libffi/ChangeLog.libgcj \
		$(d_ffid)/$(docdir)/$(p_base)/libffi/changelog.libgcj

	debian/dh_doclink -p$(p_ffi) $(p_base)
	debian/dh_doclink -p$(p_ffid) $(p_base)
	debian/dh_doclink -p$(p_ffidbg) $(p_base)

	debian/dh_rmemptydirs -p$(p_ffi)
	debian/dh_rmemptydirs -p$(p_ffid)
	debian/dh_rmemptydirs -p$(p_ffidbg)

	dh_strip -p$(p_ffi) -p$(p_ffid) --dbg-package=$(p_ffidbg)
	dh_compress -p$(p_ffi) -p$(p_ffid) -p$(p_ffidbg)
	dh_fixperms -p$(p_ffi) -p$(p_ffid) -p$(p_ffid)
	dh_makeshlibs -p$(p_ffi) -V '$(p_ffi) (>= $(DEB_FFI_SOVERSION))'
	dh_shlibdeps -p$(p_ffi) -p$(p_ffid)
	dh_gencontrol -p$(p_ffi) -p$(p_ffid) -p$(p_ffidbg) \
		-- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_ffi) -p$(p_ffid) -p$(p_ffidbg)
	dh_md5sums -p$(p_ffi) -p$(p_ffid) -p$(p_ffidbg)
	dh_builddeb -p$(p_ffi) -p$(p_ffid) -p$(p_ffidbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-lib64ffi: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_l64ffi) $(d_l64ffidbg)
	dh_installdirs -p$(p_l64ffi) \
		$(PF)/lib64
	DH_COMPAT=2 dh_movefiles -p$(p_l64ffi) \
		$(PF)/lib64/libffi.so.*

	debian/dh_doclink -p$(p_l64ffi) $(p_base)
	debian/dh_doclink -p$(p_l64ffidbg) $(p_base)

	dh_strip -p$(p_l64ffi) --dbg-package=$(p_l64ffidbg)
	dh_compress -p$(p_l64ffi) -p$(p_l64ffidbg)
	dh_fixperms -p$(p_l64ffi) -p$(p_l64ffidbg)
	dh_makeshlibs -p$(p_l64ffi) -V '$(p_l64ffi) (>= $(DEB_FFI_SOVERSION))'
#	dh_shlibdeps -p$(p_l64ffi)
	dh_gencontrol -p$(p_l64ffi) -p$(p_l64ffidbg) \
		-- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_l64ffi) -p$(p_l64ffidbg)
	dh_md5sums -p$(p_l64ffi) -p$(p_l64ffidbg)
	dh_builddeb -p$(p_l64ffi) -p$(p_l64ffidbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-lib32ffi: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_l32ffi) $(d_l32ffidbg)
	dh_installdirs -p$(p_l32ffi) \
		$(lib32)
	DH_COMPAT=2 dh_movefiles -p$(p_l32ffi) \
		$(lib32)/libffi.so.*

	debian/dh_doclink -p$(p_l32ffi) $(p_base)
	debian/dh_doclink -p$(p_l32ffidbg) $(p_base)

	dh_strip -p$(p_l32ffi) --dbg-package=$(p_l32ffidbg)
	dh_compress -p$(p_l32ffi) -p$(p_l32ffidbg)
	dh_fixperms -p$(p_l32ffi) -p$(p_l32ffidbg)
	dh_makeshlibs -p$(p_l32ffi) -V '$(p_l32ffi) (>= $(DEB_FFI_SOVERSION))'
	dh_shlibdeps -p$(p_l32ffi)
	dh_gencontrol -p$(p_l32ffi) -p$(p_l32ffidbg) \
		-- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_l32ffi) -p$(p_l32ffidbg)
	dh_md5sums -p$(p_l32ffi) -p$(p_l32ffidbg)
	dh_builddeb -p$(p_l32ffi) -p$(p_l32ffidbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
