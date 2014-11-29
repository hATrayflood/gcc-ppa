ifneq (,$(filter yes, $(biarch) $(biarch32)))
  arch_binaries  := $(arch_binaries) cxx-multi
endif
arch_binaries  := $(arch_binaries) cxx

dirs_cxx = \
	$(docdir)/$(p_base)/C++ \
	$(PF)/bin \
	$(PF)/share/info \
	$(gcc_lexec_dir) \
	$(PF)/share/man/man1
files_cxx = \
	$(PF)/bin/g++$(pkg_ver) \
	$(gcc_lexec_dir)/cc1plus

ifneq ($(GFDL_INVARIANT_FREE),yes)
  files_cxx += \
	$(PF)/share/man/man1/g++$(pkg_ver).1
endif

p_cxx_m	= g++$(pkg_ver)-multilib
d_cxx_m	= debian/$(p_cxx_m)

# ----------------------------------------------------------------------
$(binary_stamp)-cxx: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_cxx)
	dh_installdirs -p$(p_cxx) $(dirs_cxx)
	DH_COMPAT=2 dh_movefiles -p$(p_cxx) $(files_cxx)

	ln -sf g++$(pkg_ver) \
	    $(d_cxx)/$(PF)/bin/$(DEB_TARGET_GNU_TYPE)-g++$(pkg_ver)
	ln -sf g++$(pkg_ver) \
	    $(d_cxx)/$(PF)/bin/$(TARGET_ALIAS)-g++$(pkg_ver)
ifneq ($(GFDL_INVARIANT_FREE),yes)
# g++ man page is a .so link
	rm -f $(d_cxx)/$(PF)/share/man/man1/g++$(pkg_ver).1
	ln -sf gcc$(pkg_ver).1.gz \
		$(d_cxx)/$(PF)/share/man/man1/g++$(pkg_ver).1.gz
	ln -sf g++$(pkg_ver).1.gz \
	    $(d_cxx)/$(PF)/share/man/man1/$(DEB_TARGET_GNU_TYPE)-g++$(pkg_ver).1.gz
	ln -sf g++$(pkg_ver).1.gz \
	    $(d_cxx)/$(PF)/share/man/man1/$(TARGET_ALIAS)-g++$(pkg_ver).1.gz
endif

	debian/dh_doclink -p$(p_cxx) $(p_base)
	cp -p debian/README.C++ $(d_cxx)/$(docdir)/$(p_base)/C++/
	cp -p $(srcdir)/gcc/cp/ChangeLog \
		$(d_cxx)/$(docdir)/$(p_base)/C++/changelog
	debian/dh_rmemptydirs -p$(p_cxx)

	dh_strip -p$(p_cxx)
	dh_compress -p$(p_cxx)
	dh_fixperms -p$(p_cxx)
	dh_shlibdeps -p$(p_cxx)
	dh_gencontrol -p$(p_cxx) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_cxx)
	dh_md5sums -p$(p_cxx)
	dh_builddeb -p$(p_cxx)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-cxx-multi: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_cxx_m)
	dh_installdirs -p$(p_cxx_m) \
		$(docdir) \
		$(gcc_lib_dir)/$(biarchsubdir)

ifeq ($(biarch),yes)
	mv $(d)/$(PF)/lib64/lib*c++*.{a,so} $(d)/$(gcc_lib_dir)/$(biarchsubdir)/.
endif
ifeq ($(biarch32),yes)
	mv $(d)/$(lib32)/lib*c++*.{a,so} $(d)/$(gcc_lib_dir)/$(biarchsubdir)/.
endif

	DH_COMPAT=2 dh_movefiles -p$(p_cxx_m) \
		$(gcc_lib_dir)/$(biarchsubdir)/libstdc++.{a,so} \
	        $(gcc_lib_dir)/$(biarchsubdir)/libsupc++.a \
		$(gcc_lib_dir)/$(biarchsubdir)/libstdc++_pic.a

ifeq ($(biarch),yes)
	dh_link -p$(p_cxx_m) \
		/$(PF)/lib64/libstdc++.so.$(CXX_SONAME) \
		/$(gcc_lib_dir)/$(biarchsubdir)/libstdc++.so
endif
ifeq ($(biarch32),yes)
	dh_link -p$(p_cxx_m) \
		/$(lib32)/libstdc++.so.$(CXX_SONAME) \
		/$(gcc_lib_dir)/$(biarchsubdir)/libstdc++.so
endif

	debian/dh_doclink -p$(p_cxx_m) $(p_base)
	debian/dh_rmemptydirs -p$(p_cxx_m)

	dh_strip -p$(p_cxx_m)
	dh_compress -p$(p_cxx_m)
	dh_fixperms -p$(p_cxx_m)
	dh_shlibdeps -p$(p_cxx_m)
	dh_gencontrol -p$(p_cxx_m) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_cxx_m)
	dh_md5sums -p$(p_cxx_m)
	dh_builddeb -p$(p_cxx_m)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
