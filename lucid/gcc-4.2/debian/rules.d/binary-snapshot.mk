arch_binaries  := $(arch_binaries) snapshot

p_snap	= gcc-snapshot
d_snap	= debian/$(p_snap)

dirs_snap = \
	$(docdir)/$(p_snap) \
	usr/lib

# ----------------------------------------------------------------------
$(binary_stamp)-snapshot: $(install_snap_stamp)
	dh_testdir
	dh_testroot
	mv $(install_snap_stamp) $(install_snap_stamp)-tmp

	rm -rf $(d_snap)
	dh_installdirs -p$(p_snap) $(dirs_snap)

	-find $(d) -name '*.gch' -type d | xargs rm -rf

	mv $(d)/$(PF) $(d_snap)/usr/lib/

	rm -rf $(d_snap)/$(PF)/lib/nof

ifeq ($(with_hppa64),yes)
	: # provide as and ld links
	dh_link -p $(p_snap) \
		/usr/bin/hppa64-linux-gnu-as \
		/$(PF)/libexec/gcc/hppa64-linux-gnu/$(GCC_VERSION)/as \
		/usr/bin/hppa64-linux-gnu-ld \
		/$(PF)/libexec/gcc/hppa64-linux-gnu/$(GCC_VERSION)/ld
endif

ifeq ($(with_check),yes)
	dh_installdocs -p$(p_snap) test-summary
  ifeq ($(with_pascal),yes)
	cp -p gpc-test-summary $(d_snap)/$(docdir)/$(p_snap)/
  endif
else
	dh_installdocs -p$(p_snap)
endif
	if [ -f $(buildlibdir)/libstdc++-v3/testsuite/current_symbols.txt ]; \
	then \
	  cp -p $(buildlibdir)/libstdc++-v3/testsuite/current_symbols.txt \
	    $(d_snap)/$(docdir)/$(p_snap)/libstdc++6_symbols.txt; \
	fi
	cp -p debian/README.snapshot \
		$(d_snap)/$(docdir)/$(p_snap)/README.Debian
	dh_installchangelogs -p$(p_snap)
ifeq ($(DEB_TARGET_ARCH),hppa)
	dh_strip -p$(p_snap) -Xdebug -X.o -X.a
else
	dh_strip -p$(p_snap) -Xdebug
endif
	dh_compress -p$(p_snap)
	-find $(d_snap) -type d ! -perm 755 -exec chmod 755 {} \;
	dh_fixperms -p$(p_snap)

ifeq (0,1)
ifeq ($(biarch),yes)
	mv $(d_snap)/$(PF)/lib64 .
endif
ifeq ($(biarch32),yes)
	mv $(d_snap)/$(PF)/lib32 .
endif
	dh_shlibdeps -p$(p_snap) \
		-l$(d_snap)/$(PF)/lib:$(d_snap)/$(gcc_lib_dir)
ifeq ($(biarch),yes)
	mv lib64 $(d_snap)/$(PF)/
endif
ifeq ($(biarch32),yes)
	mv lib32 $(d_snap)/$(PF)/
endif
endif
	-dh_shlibdeps -p$(p_snap) \
		-l$(d_snap)/$(PF)/lib:$(d_snap)/$(gcc_lib_dir)

	dh_gencontrol -p$(p_snap) -- $(common_substvars)
	dh_installdeb -p$(p_snap)
	dh_md5sums -p$(p_snap)
	dh_builddeb -p$(p_snap)

	trap '' 1 2 3 15; touch $@; mv $(install_snap_stamp)-tmp $(install_snap_stamp)
