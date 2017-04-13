ifneq ($(DEB_STAGE),rtlibs)
  ifneq (,$(filter yes, $(biarch64) $(biarch32) $(biarchn32) $(biarchx32) $(biarchhf) $(biarchsf)))
    arch_binaries  := $(arch_binaries) cxx-multi
  endif
  arch_binaries  := $(arch_binaries) cxx
endif

dirs_cxx = \
	$(docdir)/$(p_xbase)/C++ \
	$(PF)/bin \
	$(PF)/share/info \
	$(gcc_lexec_dir) \
	$(PF)/share/man/man1
files_cxx = \
	$(PF)/bin/$(cmd_prefix)g++$(pkg_ver) \
	$(gcc_lexec_dir)/cc1plus

ifneq ($(GFDL_INVARIANT_FREE),yes)
  files_cxx += \
	$(PF)/share/man/man1/$(cmd_prefix)g++$(pkg_ver).1
endif

p_cxx_m	= g++$(pkg_ver)-multilib$(cross_bin_arch)
d_cxx_m	= debian/$(p_cxx_m)

# ----------------------------------------------------------------------
$(binary_stamp)-cxx: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_cxx)
	dh_installdirs -p$(p_cxx) $(dirs_cxx)
	$(dh_compat2) dh_movefiles -p$(p_cxx) $(files_cxx)

ifneq ($(DEB_CROSS),yes)
	ln -sf g++$(pkg_ver) \
	    $(d_cxx)/$(PF)/bin/$(DEB_TARGET_GNU_TYPE)-g++$(pkg_ver)
	ln -sf g++$(pkg_ver) \
	    $(d_cxx)/$(PF)/bin/$(TARGET_ALIAS)-g++$(pkg_ver)
endif

ifneq ($(GFDL_INVARIANT_FREE),yes)
# g++ man page is a .so link
	rm -f $(d_cxx)/$(PF)/share/man/man1/$(cmd_prefix)g++$(pkg_ver).1
	ln -sf $(cmd_prefix)gcc$(pkg_ver).1.gz \
		$(d_cxx)/$(PF)/share/man/man1/$(cmd_prefix)g++$(pkg_ver).1.gz
  ifneq ($(DEB_CROSS),yes)
	ln -sf g++$(pkg_ver).1.gz \
	    $(d_cxx)/$(PF)/share/man/man1/$(DEB_TARGET_GNU_TYPE)-g++$(pkg_ver).1.gz
	ln -sf g++$(pkg_ver).1.gz \
	    $(d_cxx)/$(PF)/share/man/man1/$(TARGET_ALIAS)-g++$(pkg_ver).1.gz
  endif
endif

ifeq ($(GFDL_INVARIANT_FREE),yes)
	mkdir -p $(d_cxx)/usr/share/lintian/overrides
	echo '$(p_cxx) binary: binary-without-manpage' \
	  >> $(d_cxx)/usr/share/lintian/overrides/$(p_cxx)
endif

	debian/dh_doclink -p$(p_cxx) $(p_xbase)
	cp -p debian/README.C++ $(d_cxx)/$(docdir)/$(p_xbase)/C++/
	cp -p $(srcdir)/gcc/cp/ChangeLog \
		$(d_cxx)/$(docdir)/$(p_xbase)/C++/changelog
	debian/dh_rmemptydirs -p$(p_cxx)

	dh_shlibdeps -p$(p_cxx)
	dh_strip -p$(p_cxx) $(if $(unstripped_exe),-X/cc1plus)
	echo $(p_cxx) >> debian/arch_binaries

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

$(binary_stamp)-cxx-multi: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_cxx_m)
	dh_installdirs -p$(p_cxx_m) \
		$(docdir)

	debian/dh_doclink -p$(p_cxx_m) $(p_xbase)
	debian/dh_rmemptydirs -p$(p_cxx_m)

	dh_strip -p$(p_cxx_m)
	dh_shlibdeps -p$(p_cxx_m)
	echo $(p_cxx_m) >> debian/arch_binaries

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
