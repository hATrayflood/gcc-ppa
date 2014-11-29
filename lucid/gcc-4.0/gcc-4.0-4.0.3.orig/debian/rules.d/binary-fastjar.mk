arch_binaries  := $(arch_binaries) fastjar

p_fjar	= fastjar
d_fjar	= debian/$(p_fjar)

dirs_fjar = \
	$(docdir)/$(p_fjar) \
	$(PF)/bin \
	$(PF)/share/man/man1 \
	$(PF)/share/info

files_fjar = \
	$(PF)/bin/{fastjar,grepjar}* \
	$(PF)/share/man/man1/{fastjar,grepjar}*.1 \
	$(PF)/share/info/fastjar.info

# ----------------------------------------------------------------------
$(binary_stamp)-fastjar: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_fjar)
	dh_installdirs -p$(p_fjar)  $(dirs_fjar)

#ifeq ($(versioned_packages),yes)
#	: # rename versioned files back to unversioned ones.
#	for i in fastjar grepjar; do \
#	  mv $(d)/$(PF)/bin/$$i$(pkg_ver) $(d)/$(PF)/bin/$$i; \
#	  mv $(d)/$(PF)/share/man/man1/$$i$(pkg_ver).1 \
#		$(d)/$(PF)/share/man/man1/$$i.1; \
#	done
#endif
	for i in fastjar grepjar; do \
	  ln -s $$i$(pkg_ver) $(d)/$(PF)/bin/$$i; \
	  ln -s $$i$(pkg_ver).1 $(d)/$(PF)/share/man/man1/$$i.1; \
	done

	DH_COMPAT=2 dh_movefiles -p$(p_fjar)  $(files_fjar)

	dh_installdocs -p$(p_fjar) $(srcdir)/fastjar/{CHANGES,NEWS,README}
	dh_installchangelogs -p$(p_fjar) $(srcdir)/fastjar/ChangeLog

	debian/dh_rmemptydirs -p$(p_fjar)

	dh_strip -p$(p_fjar)
	dh_compress -p$(p_fjar)
	dh_fixperms -p$(p_fjar)
	dh_shlibdeps -p$(p_fjar)
	dh_gencontrol -p$(p_fjar) -- -v$(DEB_EVERSION) $(common_substvars)
	dh_installdeb -p$(p_fjar)
	dh_md5sums -p$(p_fjar)
	dh_builddeb -p$(p_fjar)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
