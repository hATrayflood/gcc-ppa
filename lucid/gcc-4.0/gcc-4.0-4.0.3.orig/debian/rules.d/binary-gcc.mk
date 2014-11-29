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
	$(docdir)/$(p_base)/gcc \
	$(PF)/bin \
	$(gcc_lexec_dir) \
	$(gcc_lib_dir)/include \
	$(PF)/share/man/man1 $(libdir)

files_gcc = \
	$(PF)/bin/{gcc,gcov,gccbug}$(pkg_ver) \
	$(PF)/share/man/man1/{gcc,gcov,gccbug}$(pkg_ver).1 \
	$(gcc_lexec_dir)/collect2 \
	$(gcc_lib_dir)/{libgcc*,libgcov.a,*.o} \
	$(gcc_lib_dir)/include/README \
	$(gcc_lib_dir)/include/{float,iso646,limits,std*,syslimits,unwind,varargs}.h \
	$(shell for d in asm bits gnu linux; do \
		  test -e $(d)/$(gcc_lib_dir)/include/$$d \
		    && echo $(gcc_lib_dir)/include/$$d; \
		done) \
	$(shell test -e $(d)/$(gcc_lib_dir)/SYSCALLS.c.X \
		&& echo $(gcc_lib_dir)/SYSCALLS.c.X) \
	$(shell for h in {,e,p,x}mmintrin.h mm3dnow.h mm_malloc.h; do \
		  test -e $(d)/$(gcc_lib_dir)/include/$$h \
		    && echo $(gcc_lib_dir)/include/$$h; \
		done) \

ifeq ($(biarch),yes)
    files_gcc += $(gcc_lib_dir)/64/{libgcc*,libgcov.a,*.o}
endif
ifeq ($(biarch32),yes)
    files_gcc += $(gcc_lib_dir)/32/{libgcc*,*.o}
endif

ifeq ($(DEB_HOST_ARCH),ia64)
    files_gcc += $(gcc_lib_dir)/include/ia64intrin.h
endif

ifeq ($(DEB_HOST_ARCH),m68k)
    files_gcc += $(gcc_lib_dir)/include/math-68881.h
endif

ifeq ($(DEB_TARGET_ARCH),$(findstring $(DEB_TARGET_ARCH),powerpc ppc64))
    files_gcc += $(gcc_lib_dir)/include/{altivec.h,ppc-asm.h}
endif

usr_doc_files = debian/README.Bugs \
	$(shell test -f $(srcdir)/FAQ && echo $(srcdir)/FAQ)
ifeq ($(with_check),yes)
  usr_doc_files += test-summary
endif

p_loc	= gcc$(pkg_ver)-locales
d_loc	= debian/$(p_loc)

# ----------------------------------------------------------------------
$(binary_stamp)-gcc: $(install_dependencies)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_gcc)
	dh_installdirs -p$(p_gcc) $(dirs_gcc)

	rm -f $(d)/$(PF)/$(libdir)/libgcc_s.so
	ln -sf /$(libdir)/libgcc_s.so.$(GCC_SONAME) $(d)/$(gcc_lib_dir)/libgcc_s.so
ifeq ($(biarch),yes)
	rm -f $(d)/$(PF)/$(lib64)/libgcc_s.so
	dh_link -p$(p_gcc) \
	  /$(lib64)/libgcc_s.so.$(GCC_SONAME) /$(gcc_lib_dir)/libgcc_s_64.so \
	  /$(lib64)/libgcc_s.so.$(GCC_SONAME) /$(gcc_lib_dir)/64/libgcc_s.so
endif
ifeq ($(biarch32),yes)
	mkdir -p $(d_gcc)/$(gcc_lib_dir)
	mv $(d)/$(gcc_lib_dir)/32 $(d_gcc)/$(gcc_lib_dir)/
	dh_link -p$(p_gcc) \
	  /$(lib32)/libgcc_s.so.$(GCC_SONAME)  /$(gcc_lib_dir)/libgcc_s_32.so \
	  /$(lib32)/libgcc_s.so.$(GCC_SONAME)  /$(gcc_lib_dir)/32/libgcc_s_32.so \
	  /$(lib32)/libgcc_s.so.$(GCC_SONAME)  /$(gcc_lib_dir)/32/libgcc_s.so
endif
	cp -p debian/gccbug.1 $(d)/$(PF)/share/man/man1/gccbug$(pkg_ver).1

	DH_COMPAT=2 dh_movefiles -p$(p_gcc) $(files_gcc)

	ln -sf gcc$(pkg_ver) \
	    $(d_gcc)/$(PF)/bin/$(DEB_TARGET_GNU_TYPE)-gcc$(pkg_ver)
	ln -sf gcc$(pkg_ver).1 \
	    $(d_gcc)/$(PF)/share/man/man1/$(DEB_TARGET_GNU_TYPE)-gcc$(pkg_ver).1
	ln -sf gcc$(pkg_ver) \
	    $(d_gcc)/$(PF)/bin/$(TARGET_ALIAS)-gcc$(pkg_ver)
	ln -sf gcc$(pkg_ver).1 \
	    $(d_gcc)/$(PF)/share/man/man1/$(TARGET_ALIAS)-gcc$(pkg_ver).1

#	dh_installdebconf
	debian/dh_doclink -p$(p_gcc) $(p_base)
	cp -p $(usr_doc_files) $(d_gcc)/$(docdir)/$(p_base)/.
	if [ -f testsuite-comparision ]; then \
	  cp -p testsuite-comparision $(d_gcc)/$(docdir)/$(p_base)/. ; \
	fi
	cp -p debian/NEWS.gcc $(d_gcc)/$(docdir)/$(p_base)/NEWS
	cp -p debian/NEWS.html $(d_gcc)/$(docdir)/$(p_base)/NEWS.html
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
	for d in `find $(d) -depth -type d -empty 2> /dev/null`; do \
	    while rmdir $$d 2> /dev/null; do d=`dirname $$d`; done; \
	done

	@echo "Listing installed files not included in any package:"
	-find $(d) ! -type d

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

	debian/dh_doclink -p$(p_doc) $(p_base)
	dh_installdocs -p$(p_doc) html/gcc.html html/gccint.html
	rm -f $(d_doc)/$(docdir)/$(p_base)/copyright
	debian/dh_rmemptydirs -p$(p_doc)

	dh_compress -p$(p_doc)
	dh_fixperms -p$(p_doc)
	dh_installdeb -p$(p_doc)
	dh_gencontrol -p$(p_doc) -- -v$(DEB_VERSION) $(common_substvars)
	dh_md5sums -p$(p_doc)
	dh_builddeb -p$(p_doc)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
