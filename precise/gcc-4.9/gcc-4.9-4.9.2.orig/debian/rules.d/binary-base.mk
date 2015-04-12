$(lib_binaries) += base

# ---------------------------------------------------------------------------
# gcc-base

ifneq (,$(filter $(distrelease),oneiric precise wheezy sid))
  additional_links =
else ifneq (,$(filter $(distrelease),))
  additional_links =
else
  additional_links =
endif

$(binary_stamp)-base: $(install_dependencies)
	dh_testdir
	dh_testroot
	rm -rf $(d_base)
	dh_installdirs -p$(p_base) \
		$(gcc_lexec_dir)

	ln -sf $(BASE_VERSION) \
	    $(d_base)/$(subst /$(BASE_VERSION),/$(GCC_VERSION),$(gcc_lib_dir))
	for link in $(additional_links); do \
	  ln -sf $(BASE_VERSION) \
	    $(d_base)/$$(dirname $(gcc_lib_dir))/$$link; \
        done
ifneq ($(gcc_lib_dir),$(gcc_lexec_dir))
	ln -sf $(BASE_VERSION) \
	    $(d_base)/$(subst /$(BASE_VERSION),/$(GCC_VERSION),$(gcc_lexec_dir))
	for link in $(additional_links); do \
	  ln -sf $(BASE_VERSION) \
	    $(d_base)/$$(dirname $(gcc_lexec_dir))/$$link; \
        done
endif

ifeq ($(with_base_only),yes)
	dh_installdocs -p$(p_base) debian/README.Debian
else
	dh_installdocs -p$(p_base) debian/README.Debian.$(DEB_TARGET_ARCH)
endif
	rm -f $(d_base)/usr/share/doc/$(p_base)/README.Debian
	dh_installchangelogs -p$(p_base)
	dh_compress -p$(p_base)
	dh_fixperms -p$(p_base)
	dh_gencontrol -p$(p_base) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_base)
	dh_md5sums -p$(p_base)
	dh_builddeb -p$(p_base)
	touch $@
