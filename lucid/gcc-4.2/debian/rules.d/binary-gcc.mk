ifneq (,$(filter yes, $(biarch) $(biarch32)))
  arch_binaries  := $(arch_binaries) gcc-multi
endif
arch_binaries  := $(arch_binaries) gcc
ifneq ($(GFDL_INVARIANT_FREE),yes)
  indep_binaries := $(indep_binaries) gcc-doc
endif
ifeq ($(with_nls),yes)
  indep_binaries := $(indep_binaries) gcc-locales
endif

# gcc must be moved after g77 and g++
# not all files $(PF)/include/*.h are part of gcc,
# but it becomes difficult to name all these files ...

dirs_gcc = \
	$(docdir)/$(p_base)/{gcc,libssp,gomp} \
	$(PF)/bin \
	$(gcc_lexec_dir) \
	$(gcc_lib_dir)/{include,include-fixed} \
	$(PF)/share/man/man1 $(libdir)

files_gcc = \
	$(PF)/bin/{gcc,gcov}$(pkg_ver) \
	$(gcc_lexec_dir)/collect2 \
	$(gcc_lib_dir)/{libgcc*,libgcov.a,*.o} \
	$(gcc_lib_dir)/include/std*.h \
	$(shell for h in \
		    README features.h \
		    {decfloat,float,iso646,limits,syslimits,unwind,varargs}.h \
		    {,e,p,x}mmintrin.h mm3dnow.h mm_malloc.h; \
		do \
		  test -e $(d)/$(gcc_lib_dir)/include/$$h \
		    && echo $(gcc_lib_dir)/include/$$h; \
		  test -e $(d)/$(gcc_lib_dir)/include-fixed/$$h \
		    && echo $(gcc_lib_dir)/include-fixed/$$h; \
		done) \
	$(shell for d in \
		  asm bits gnu linux $(TARGET_ALIAS) \
		  $(subst $(DEB_TARGET_GNU_CPU),$(biarch_cpu),$(TARGET_ALIAS)); \
		do \
		  test -e $(d)/$(gcc_lib_dir)/include/$$d \
		    && echo $(gcc_lib_dir)/include/$$d; \
		  test -e $(d)/$(gcc_lib_dir)/include-fixed/$$d \
		    && echo $(gcc_lib_dir)/include-fixed/$$d; \
		done) \
	$(shell test -e $(d)/$(gcc_lib_dir)/SYSCALLS.c.X \
		&& echo $(gcc_lib_dir)/SYSCALLS.c.X)

ifneq ($(GFDL_INVARIANT_FREE),yes)
    files_gcc += \
	$(PF)/share/man/man1/{gcc,gcov}$(pkg_ver).1
endif

ifeq ($(with_libssp),yes)
    files_gcc += $(gcc_lib_dir)/include/ssp
endif
ifeq ($(with_gomp),yes)
    files_gcc += $(gcc_lib_dir)/include/omp.h
endif

ifeq ($(DEB_HOST_ARCH),ia64)
    files_gcc += $(gcc_lib_dir)/include/ia64intrin.h
endif

ifeq ($(DEB_HOST_ARCH),m68k)
    files_gcc += $(gcc_lib_dir)/include/math-68881.h
endif

ifeq ($(DEB_TARGET_ARCH),$(findstring $(DEB_TARGET_ARCH),powerpc ppc64))
    files_gcc += $(gcc_lib_dir)/include/{altivec.h,ppc-asm.h,spe.h}
endif

usr_doc_files = debian/README.Bugs \
	$(shell test -f $(srcdir)/FAQ && echo $(srcdir)/FAQ) \
	$(shell test -f test-summary && echo test-summary)

p_loc	= gcc$(pkg_ver)-locales
d_loc	= debian/$(p_loc)

p_gcc_m	= gcc$(pkg_ver)-multilib
d_gcc_m	= debian/$(p_gcc_m)

# ----------------------------------------------------------------------
$(binary_stamp)-gcc: $(install_dependencies)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_gcc)
	dh_installdirs -p$(p_gcc) $(dirs_gcc)

	rm -f $(d)/$(PF)/$(libdir)/libgcc_s.so
	ln -sf /$(libdir)/libgcc_s.so.$(GCC_SONAME) $(d)/$(gcc_lib_dir)/libgcc_s.so

ifeq ($(with_libgmath),yes)
	rm -f $(d)/$(PF)/$(libdir)/libgcc-math.{la,so}
	dh_link -p$(p_gcc) \
	  /$(PF)/$(libdir)/libgcc-math.so.$(GCC_SONAME) /$(gcc_lib_dir)/libgcc-math.so
	mv $(d)/$(PF)/$(libdir)/libgcc-math.a $(d)/$(gcc_lib_dir)/
endif

ifeq ($(with_libssp),yes)
	mv $(d)/$(PF)/lib/libssp*.a $(d_gcc)/$(gcc_lib_dir)/
	rm -f $(d)/$(PF)/lib/libssp*.{la,so}
	dh_link -p$(p_gcc) \
	  /$(PF)/lib/libssp.so.$(SSP_SONAME) /$(gcc_lib_dir)/libssp.so
	cp -p $(srcdir)/libssp/ChangeLog \
		$(d_gcc)/$(docdir)/$(p_base)/libssp/changelog
endif
ifeq ($(with_gomp),yes)
	mv $(d)/$(PF)/lib/libgomp*.{a,spec} $(d_gcc)/$(gcc_lib_dir)/
	rm -f $(d)/$(PF)/lib/libgomp*.{la,so}
	dh_link -p$(p_gcc) \
	  /$(PF)/lib/libgomp.so.$(GOMP_SONAME) /$(gcc_lib_dir)/libgomp.so
	cp -p $(srcdir)/libgomp/ChangeLog \
		$(d_gcc)/$(docdir)/$(p_base)/gomp/changelog
endif

	DH_COMPAT=2 dh_movefiles -p$(p_gcc) $(files_gcc)

	ln -sf gcc$(pkg_ver) \
	    $(d_gcc)/$(PF)/bin/$(DEB_TARGET_GNU_TYPE)-gcc$(pkg_ver)
	ln -sf gcc$(pkg_ver) \
	    $(d_gcc)/$(PF)/bin/$(TARGET_ALIAS)-gcc$(pkg_ver)
ifneq ($(GFDL_INVARIANT_FREE),yes)
	ln -sf gcc$(pkg_ver).1 \
	    $(d_gcc)/$(PF)/share/man/man1/$(DEB_TARGET_GNU_TYPE)-gcc$(pkg_ver).1
	ln -sf gcc$(pkg_ver).1 \
	    $(d_gcc)/$(PF)/share/man/man1/$(TARGET_ALIAS)-gcc$(pkg_ver).1
endif

#	dh_installdebconf
	debian/dh_doclink -p$(p_gcc) $(p_base)
	cp -p $(usr_doc_files) $(d_gcc)/$(docdir)/$(p_base)/.
	if [ -f testsuite-comparision ]; then \
	  cp -p testsuite-comparision $(d_gcc)/$(docdir)/$(p_base)/. ; \
	fi
	cp -p debian/README.ssp $(d_gcc)/$(docdir)/$(p_base)/
	cp -p debian/NEWS.gcc $(d_gcc)/$(docdir)/$(p_base)/NEWS
	cp -p debian/NEWS.html $(d_gcc)/$(docdir)/$(p_base)/NEWS.html
	cp -p $(srcdir)/ChangeLog $(d_gcc)/$(docdir)/$(p_base)/changelog
	cp -p $(srcdir)/gcc/ChangeLog \
		$(d_gcc)/$(docdir)/$(p_base)/gcc/changelog
	if [ -f $(builddir)/gcc/.bad_compare ]; then \
	  ( \
	    echo "The comparision of the stage2 and stage3 object files shows differences."; \
	    echo "The Debian package was modified to ignore these differences."; \
	    echo ""; \
	    echo "The following files differ:"; \
	    echo ""; \
	    cat $(builddir)/gcc/.bad_compare; \
	  ) > $(d_gcc)/$(docdir)/$(p_base)/BOOTSTRAP_COMPARISION_FAILURE; \
	else \
	  true; \
	fi
	debian/dh_rmemptydirs -p$(p_gcc)
	dh_strip -p$(p_gcc)
	dh_compress -p$(p_gcc) -X README.Bugs
	dh_fixperms -p$(p_gcc)
	dh_shlibdeps -p$(p_gcc)
	dh_gencontrol -p$(p_gcc) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_gcc)
	dh_md5sums -p$(p_gcc)
	dh_builddeb -p$(p_gcc)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

	: # remove empty directories, when all components are in place
	-find $(d) -type d -empty -delete

	@echo "Listing installed files not included in any package:"
	-find $(d) ! -type d

# ----------------------------------------------------------------------
$(binary_stamp)-gcc-multi: $(install_dependencies)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_gcc_m)
	dh_installdirs -p$(p_gcc_m) \
		$(docdir) \
		$(gcc_lib_dir)/$(biarchsubdir) \

ifeq ($(biarch),yes)
	DH_COMPAT=2 dh_movefiles -p$(p_gcc_m) \
		$(gcc_lib_dir)/$(biarchsubdir)/{libgcc*,libgcov.a,*.o}
	rm -f $(d)/$(PF)/$(lib64)/libgcc_s.so
	dh_link -p$(p_gcc_m) \
	  /$(lib64)/libgcc_s.so.$(GCC_SONAME) /$(gcc_lib_dir)/libgcc_s_64.so \
	  /$(lib64)/libgcc_s.so.$(GCC_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libgcc_s.so
  ifeq ($(with_lib64gmath),yes)
	rm -f $(d)/$(PF)/$(lib64)/libgcc-math.{la,so}
	dh_link -p$(p_gcc_m) \
	  /$(PF)/$(lib64)/libgcc-math.so.$(GCC_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libgcc-math.so
	mv $(d)/$(PF)/$(lib64)/libgcc-math.a $(d)/$(gcc_lib_dir)/$(biarchsubdir)/
  endif
endif
ifeq ($(biarch32),yes)
	DH_COMPAT=2 dh_movefiles -p$(p_gcc_m) \
		$(gcc_lib_dir)/$(biarchsubdir)/{libgcc*,libgcov.a,*.o}
	rm -f $(d)/$(lib32)/libgcc_s.so
	dh_link -p$(p_gcc_m) \
	  /$(lib32)/libgcc_s.so.$(GCC_SONAME)  /$(gcc_lib_dir)/libgcc_s_32.so \
	  /$(lib32)/libgcc_s.so.$(GCC_SONAME)  /$(gcc_lib_dir)/$(biarchsubdir)/libgcc_s.so
  ifeq ($(with_lib32gmath),yes)
	rm -f $(d)/$(lib32)/libgcc-math.{la,so}
	dh_link -p$(p_gcc_m) \
	  /$(lib32)/libgcc-math.so.$(GCC_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libgcc-math.so
	mv $(d)/$(lib32)/libgcc-math.a $(d)/$(gcc_lib_dir)/$(biarchsubdir)/
  endif
endif

ifeq ($(with_libssp),yes)
  ifeq ($(biarch),yes)
	mv $(d)/$(PF)/$(lib64)/libssp*.a $(d_gcc_m)/$(gcc_lib_dir)/$(biarchsubdir)/
	rm -f $(d)/$(PF)/$(lib64)/$(biarchsubdir)/libssp*.{la,so}
	dh_link -p$(p_gcc_m) \
	  /$(PF)/$(lib64)/libssp.so.$(SSP_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libssp.so
  endif
  ifeq ($(biarch32),yes)
	mv $(d)/$(lib32)/libssp*.a $(d_gcc_m)/$(gcc_lib_dir)/$(biarchsubdir)/
	rm -f $(d)/$(lib32)/$(biarchsubdir)/libssp*.{la,so}
	dh_link -p$(p_gcc_m) \
	  /$(lib32)/libssp.so.$(SSP_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libssp.so
  endif
endif

ifeq ($(with_gomp),yes)
  ifeq ($(biarch),yes)
	mv $(d)/$(PF)/$(lib64)/libgomp*.a $(d_gcc_m)/$(gcc_lib_dir)/$(biarchsubdir)/
	rm -f $(d)/$(PF)/$(lib64)/$(biarchsubdir)/libgomp*.{la,so}
	dh_link -p$(p_gcc_m) \
	  /$(PF)/$(lib64)/libgomp.so.$(GOMP_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libgomp.so
  endif
  ifeq ($(biarch32),yes)
	mv $(d)/$(lib32)/libgomp*.a $(d_gcc_m)/$(gcc_lib_dir)/$(biarchsubdir)/
	rm -f $(d)/$(lib32)/$(biarchsubdir)/libgomp*.{la,so}
	dh_link -p$(p_gcc_m) \
	  /$(lib32)/libgomp.so.$(GOMP_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libgomp.so
  endif
endif

	debian/dh_doclink -p$(p_gcc_m) $(p_base)
	debian/dh_rmemptydirs -p$(p_gcc_m)

	dh_strip -p$(p_gcc_m)
	dh_compress -p$(p_gcc_m)
	dh_shlibdeps -p$(p_gcc_m)
	dh_fixperms -p$(p_gcc_m)
	dh_installdeb -p$(p_gcc_m)
	dh_gencontrol -p$(p_gcc_m) -- -v$(DEB_VERSION) $(common_substvars)
	dh_md5sums -p$(p_gcc_m)
	dh_builddeb -p$(p_gcc_m)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-gcc-locales: $(install_dependencies)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_loc)
	dh_installdirs -p$(p_loc) \
		$(docdir)
	DH_COMPAT=2 dh_movefiles -p$(p_loc) \
		$(PF)/share/locale/*/*/cpplib*.* \
		$(PF)/share/locale/*/*/gcc*.*

	debian/dh_doclink -p$(p_loc) $(p_base)
	debian/dh_rmemptydirs -p$(p_loc)

	dh_compress -p$(p_loc)
	dh_fixperms -p$(p_loc)
	dh_installdeb -p$(p_loc)
	dh_gencontrol -p$(p_loc) -- -v$(DEB_VERSION) $(common_substvars)
	dh_md5sums -p$(p_loc)
	dh_builddeb -p$(p_loc)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-gcc-doc: $(build_html_stamp) $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_doc)
	dh_installdirs -p$(p_doc) \
		$(docdir)/$(p_base) \
		$(PF)/share/info
	DH_COMPAT=2 dh_movefiles -p$(p_doc) \
		$(PF)/share/info/gcc*
	rm -f $(d_doc)/$(PF)/share/info/gccinst*

ifeq ($(with_gomp),yes)
	$(MAKE) -C $(buildlibdir)/libgomp stamp-build-info
	cp -p $(buildlibdir)/libgomp/libgomp$(pkg_ver).info $(d_doc)/$(PF)/share/info/
endif

	debian/dh_doclink -p$(p_doc) $(p_base)
	dh_installdocs -p$(p_doc) html/gcc.html html/gccint.html
ifeq ($(with_gomp),yes)
	cp -p html/libgomp.html $(d_doc)/usr/share/doc/$(p_doc)/
endif
	rm -f $(d_doc)/$(docdir)/$(p_base)/copyright
	debian/dh_rmemptydirs -p$(p_doc)

	dh_compress -p$(p_doc)
	dh_fixperms -p$(p_doc)
	dh_installdeb -p$(p_doc)
	dh_gencontrol -p$(p_doc) -- -v$(DEB_VERSION) $(common_substvars)
	dh_md5sums -p$(p_doc)
	dh_builddeb -p$(p_doc)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
