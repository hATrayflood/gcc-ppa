ifneq ($(DEB_STAGE),rtlibs)
  arch_binaries  := $(arch_binaries) cpp
  ifneq ($(DEB_CROSS),yes)
    ifneq ($(GFDL_INVARIANT_FREE),yes)
      indep_binaries := $(indep_binaries) cpp-doc
    endif
  endif
endif

dirs_cpp = \
	$(docdir) \
	$(PF)/share/man/man1 \
	$(PF)/bin \
	$(gcc_lexec_dir)

files_cpp = \
	$(PF)/bin/$(cmd_prefix)cpp$(pkg_ver) \
	$(gcc_lexec_dir)/cc1 \
	$(gcc_lexec_dir)/liblto_plugin.so{,.0,.0.0.0}

ifneq ($(GFDL_INVARIANT_FREE),yes)
  files_cpp += \
	$(PF)/share/man/man1/$(cmd_prefix)cpp$(pkg_ver).1
endif

# ----------------------------------------------------------------------
$(binary_stamp)-cpp: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_cpp)
	dh_installdirs -p$(p_cpp) $(dirs_cpp)
	$(dh_compat2) dh_movefiles -p$(p_cpp) $(files_cpp)

ifneq ($(DEB_CROSS),yes)
	ln -sf cpp$(pkg_ver) \
	    $(d_cpp)/$(PF)/bin/$(DEB_TARGET_GNU_TYPE)-cpp$(pkg_ver)
	ln -sf cpp$(pkg_ver) \
	    $(d_cpp)/$(PF)/bin/$(TARGET_ALIAS)-cpp$(pkg_ver)
  ifneq ($(GFDL_INVARIANT_FREE),yes)
	ln -sf cpp$(pkg_ver).1 \
	    $(d_cpp)/$(PF)/share/man/man1/$(DEB_TARGET_GNU_TYPE)-cpp$(pkg_ver).1
	ln -sf cpp$(pkg_ver).1 \
	    $(d_cpp)/$(PF)/share/man/man1/$(TARGET_ALIAS)-cpp$(pkg_ver).1
  endif
endif

ifeq ($(GFDL_INVARIANT_FREE),yes)
	mkdir -p $(d_cpp)/usr/share/lintian/overrides
	echo '$(p_cpp) binary: binary-without-manpage' \
	  >> $(d_cpp)/usr/share/lintian/overrides/$(p_cpp)
endif

	debian/dh_doclink -p$(p_cpp) $(p_xbase)
	debian/dh_rmemptydirs -p$(p_cpp)

	dh_strip -p$(p_cpp) \
	  $(if $(unstripped_exe),-X/cc1)
	dh_shlibdeps -p$(p_cpp)
	echo $(p_cpp) >> debian/arch_binaries

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-cpp-doc: $(build_html_stamp) $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_cppd)
	dh_installdirs -p$(p_cppd) \
		$(docdir)/$(p_xbase) \
		$(PF)/share/info
	$(dh_compat2) dh_movefiles -p$(p_cppd) \
		$(PF)/share/info/cpp*

	debian/dh_doclink -p$(p_cppd) $(p_xbase)
	dh_installdocs -p$(p_cppd) html/cpp.html html/cppinternals.html
	rm -f $(d_cppd)/$(docdir)/$(p_xbase)/copyright
	debian/dh_rmemptydirs -p$(p_cppd)
	echo $(p_cppd) >> debian/indep_binaries

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
