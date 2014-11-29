ifeq ($(with_libfortran),yes)
  arch_binaries  := $(arch_binaries) libfortran
endif
ifeq ($(with_lib64fortran),yes)
  arch_binaries  := $(arch_binaries) lib64fortran
endif
ifeq ($(with_lib32fortran),yes)
  arch_binaries	:= $(arch_binaries) lib32fortran
endif

ifeq ($(with_fdev),yes)
  arch_binaries  := $(arch_binaries) fdev libfortran-dev
  ifneq ($(GFDL_INVARIANT_FREE),yes)
    indep_binaries := $(indep_binaries) fortran-doc
  endif
endif

p_g95	= gfortran$(pkg_ver)
p_g95d	= gfortran$(pkg_ver)-doc
p_flib	= libgfortran$(FORTRAN_SONAME)
p_f32lib= lib32gfortran$(FORTRAN_SONAME)
p_f64lib= lib64gfortran$(FORTRAN_SONAME)
p_flibd	= libgfortran$(FORTRAN_SONAME)-dev

d_g95	= debian/$(p_g95)
d_g95d	= debian/$(p_g95d)
d_flib	= debian/$(p_flib)
d_f32lib= debian/$(p_f32lib)
d_f64lib= debian/$(p_f64lib)
d_flibd	= debian/$(p_flibd)

dirs_g95 = \
	$(docdir)/$(p_base)/fortran \
	$(PF)/bin \
	$(gcc_lexec_dir) \
	$(gcc_lib_dir)/include \
	$(PF)/include \
	$(PF)/share/man/man1
files_g95 = \
	$(PF)/bin/gfortran$(pkg_ver) \
	$(PF)/share/man/man1/gfortran$(pkg_ver).1 \
	$(gcc_lexec_dir)/f951 


dirs_flib = \
	$(docdir)/$(p_base)/fortran \
	$(PF)/$(libdir) \

files_flib = \
	$(PF)/$(libdir)/libgfortran.so.*

dirs_flibd = \
	$(docdir)/$(p_base)/fortran \
	$(PF)/$(libdir) \

files_flibd = \
	$(PF)/lib/libgfortran.{a,la,so} \
	$(PF)/lib/libgfortranbegin.{a,la}

ifeq ($(with_lib64fortran),yes)
	dirs_flibd  += $(PF)/lib64
	files_flibd += \
		$(PF)/lib64/libgfortran.{a,la,so} \
		$(PF)/lib64/libgfortranbegin.{a,la}
endif
ifeq ($(with_lib32fortran),yes)
	dirs_flibd  += $(lib32)
	files_flibd += \
		$(lib32)/libgfortran.{a,la,so} \
		$(lib32)/libgfortranbegin.{a,la}
endif

# ----------------------------------------------------------------------
$(binary_stamp)-libfortran: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_flib)
	dh_installdirs -p$(p_flib) $(dirs_flib)
	DH_COMPAT=2 dh_movefiles -p$(p_flib) $(files_flib)
	debian/dh_doclink -p$(p_flib) $(p_base)

	dh_strip -p$(p_flib)
	dh_compress -p$(p_flib)
	dh_fixperms -p$(p_flib)
	dh_makeshlibs -p$(p_flib) -V '$(p_flib) (>= $(DEB_SOVERSION))'
	dh_shlibdeps -p$(p_flib)
	dh_gencontrol -p$(p_flib) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_flib)
	dh_md5sums -p$(p_flib)
	dh_builddeb -p$(p_flib)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-libfortran-dev: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_flibd)
	dh_installdirs -p$(p_flibd) $(dirs_flibd)
	DH_COMPAT=2 dh_movefiles -p$(p_flibd) $(files_flibd)
	debian/dh_doclink -p$(p_flibd) $(p_base)

	debian/dh_rmemptydirs -p$(p_flibd)

	dh_strip -p$(p_flibd)
	dh_compress -p$(p_flibd)
	dh_fixperms -p$(p_flibd)
	dh_shlibdeps -p$(p_flibd)
	dh_gencontrol -p$(p_flibd) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_flibd)
	dh_md5sums -p$(p_flibd)
	dh_builddeb -p$(p_flibd)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-lib64fortran: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_f64lib)
	dh_installdirs -p$(p_f64lib) \
		$(PF)/lib64
	DH_COMPAT=2 dh_movefiles -p$(p_f64lib) \
		$(PF)/lib64/libgfortran.so.*

	debian/dh_doclink -p$(p_f64lib) $(p_base)

	dh_strip -p$(p_f64lib)
	dh_compress -p$(p_f64lib)
	dh_fixperms -p$(p_f64lib)
	dh_makeshlibs -p$(p_f64lib) -V '$(p_f64lib) (>= $(DEB_SOVERSION))'
#	dh_shlibdeps -p$(p_f64lib)
	dh_gencontrol -p$(p_f64lib) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_f64lib)
	dh_md5sums -p$(p_f64lib)
	dh_builddeb -p$(p_f64lib)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-lib32fortran: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_f32lib)
	dh_installdirs -p$(p_f32lib) \
		$(PF)/lib32
	DH_COMPAT=2 dh_movefiles -p$(p_f32lib) \
		$(lib32)/libgfortran.so.*

	debian/dh_doclink -p$(p_f32lib) $(p_base)

	dh_strip -p$(p_f32lib)
	dh_compress -p$(p_f32lib)
	dh_fixperms -p$(p_f32lib)
	dh_makeshlibs -p$(p_f32lib) -V '$(p_f32lib) (>= $(DEB_SOVERSION))'
#	dh_shlibdeps -p$(p_f32lib)
	dh_gencontrol -p$(p_f32lib) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_f32lib)
	dh_md5sums -p$(p_f32lib)
	dh_builddeb -p$(p_f32lib)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-fdev: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_g95)
	dh_installdirs -p$(p_g95) $(dirs_g95)

	DH_COMPAT=2 dh_movefiles -p$(p_g95) $(files_g95)

	ln -sf gfortran$(pkg_ver) \
	    $(d_g95)/$(PF)/bin/$(DEB_TARGET_GNU_TYPE)-gfortran$(pkg_ver)
	ln -sf gfortran$(pkg_ver).1 \
	    $(d_g95)/$(PF)/share/man/man1/$(DEB_TARGET_GNU_TYPE)-gfortran$(pkg_ver).1
	ln -sf gfortran$(pkg_ver) \
	    $(d_g95)/$(PF)/bin/$(TARGET_ALIAS)-gfortran$(pkg_ver)
	ln -sf gfortran$(pkg_ver).1 \
	    $(d_g95)/$(PF)/share/man/man1/$(TARGET_ALIAS)-gfortran$(pkg_ver).1

	debian/dh_doclink -p$(p_g95) $(p_base)

	cp -p $(srcdir)/gcc/fortran/ChangeLog \
		$(d_g95)/$(docdir)/$(p_base)/fortran/changelog
	debian/dh_rmemptydirs -p$(p_g95)

	dh_strip -p$(p_g95)
	dh_compress -p$(p_g95)
	dh_fixperms -p$(p_g95)
	dh_shlibdeps -p$(p_g95)
	dh_gencontrol -p$(p_g95) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_g95)
	dh_md5sums -p$(p_g95)
	dh_builddeb -p$(p_g95)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-fortran-doc: $(build_html_stamp) $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_g95d)
	dh_installdirs -p$(p_g95d) \
		$(docdir)/$(p_base)/fortran \
		$(PF)/share/info
	DH_COMPAT=2 dh_movefiles -p$(p_g95d) \
		$(PF)/share/info/gfortran*

	debian/dh_doclink -p$(p_g95d) $(p_base)
ifneq ($(GFDL_INVARIANT_FREE),yes)
	dh_installdocs -p$(p_g95d)
	rm -f $(d_g95d)/$(docdir)/$(p_base)/copyright
	cp -p html/gfortran.html $(d_g95d)/$(docdir)/$(p_base)/fortran/
endif

	dh_compress -p$(p_g95d)
	dh_fixperms -p$(p_g95d)
	dh_installdeb -p$(p_g95d)
	dh_gencontrol -p$(p_g95d) -- -v$(DEB_VERSION) $(common_substvars)
	dh_md5sums -p$(p_g95d)
	dh_builddeb -p$(p_g95d)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
