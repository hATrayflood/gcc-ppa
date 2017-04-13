ifeq ($(with_separate_gnat),yes)
  $(lib_binaries) += gnatbase
endif

ifeq ($(with_libgnat),yes)
  $(lib_binaries) += libgnat libgnatvsn libgnatprj
endif

arch_binaries := $(arch_binaries) ada
ifneq ($(DEB_CROSS),yes)
  ifneq ($(GFDL_INVARIANT_FREE),yes)
    indep_binaries := $(indep_binaries) ada-doc
  endif
endif

p_gbase		= $(p_xbase)
p_glbase	= $(p_lbase)
ifeq ($(with_separate_gnat),yes)
  p_gbase	= gnat$(pkg_ver)$(cross_bin_arch)-base
  p_glbase	= gnat$(pkg_ver)$(cross_bin_arch)-base
endif

p_gnat	= gnat-$(GNAT_VERSION)$(cross_bin_arch)
p_gnatsjlj= gnat-$(GNAT_VERSION)-sjlj$(cross_bin_arch)
p_lgnat	= libgnat-$(GNAT_VERSION)$(cross_lib_arch)
p_lgnat_dbg = libgnat-$(GNAT_VERSION)-dbg$(cross_lib_arch)
p_lgnatvsn = libgnatvsn$(GNAT_VERSION)$(cross_lib_arch)
p_lgnatvsn_dev = libgnatvsn$(GNAT_VERSION)-dev$(cross_lib_arch)
p_lgnatvsn_dbg = libgnatvsn$(GNAT_VERSION)-dbg$(cross_lib_arch)
p_lgnatprj = libgnatprj$(GNAT_VERSION)$(cross_lib_arch)
p_lgnatprj_dev = libgnatprj$(GNAT_VERSION)-dev$(cross_lib_arch)
p_lgnatprj_dbg = libgnatprj$(GNAT_VERSION)-dbg$(cross_lib_arch)
p_gnatd	= $(p_gnat)-doc

d_gbase	= debian/$(p_gbase)
d_gnat	= debian/$(p_gnat)
d_gnatsjlj	= debian/$(p_gnatsjlj)
d_lgnat	= debian/$(p_lgnat)
d_lgnatvsn = debian/$(p_lgnatvsn)
d_lgnatvsn_dev = debian/$(p_lgnatvsn_dev)
d_lgnatprj = debian/$(p_lgnatprj)
d_lgnatprj_dev = debian/$(p_lgnatprj_dev)
d_gnatd	= debian/$(p_gnatd)

GNAT_TOOLS = gnat gnatbind gnatchop gnatclean gnatfind gnatkr gnatlink \
	     gnatls gnatmake gnatname gnatprep gnatxref gnathtml

ifeq ($(with_gnatsjlj),yes)
	rts_subdir = 
endif

dirs_gnat = \
	$(docdir)/$(p_gbase) \
	$(PF)/bin \
	$(PF)/share/man/man1 \
	$(gcc_lib_dir)/{adalib,adainclude} \
	$(gcc_lexec_dir)

files_gnat = \
	$(gcc_lexec_dir)/gnat1 \
	$(gcc_lib_dir)/adainclude/*.ad[bs] \
	$(gcc_lib_dir)/adalib/*.ali \
	$(gcc_lib_dir)/adalib/lib*.a \
	$(foreach i,$(GNAT_TOOLS),$(PF)/bin/$(cmd_prefix)$(i)$(pkg_ver))

dirs_lgnat = \
	$(docdir) \
	$(PF)/lib
files_lgnat = \
	$(usr_lib)/lib{gnat,gnarl}-$(GNAT_SONAME).so.1

$(binary_stamp)-gnatbase: $(install_stamp)
	dh_testdir
	dh_testroot
	dh_installdocs -p$(p_gbase) debian/README.gnat debian/README.maintainers
	: # $(p_gbase)
ifeq ($(PKGSOURCE),gnat-$(BASE_VERSION))
	mkdir -p $(d_gbase)/$(docdir)/$(p_xbase)
	ln -sf ../$(p_gbase) $(d_gbase)/$(docdir)/$(p_xbase)/Ada
endif
	dh_installchangelogs -p$(p_gbase) src/gcc/ada/ChangeLog
	dh_compress -p$(p_gbase)
	dh_fixperms -p$(p_gbase)
	dh_gencontrol -p$(p_gbase) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_gbase)
	dh_md5sums -p$(p_gbase)
	dh_builddeb -p$(p_gbase)
	touch $@


$(binary_stamp)-libgnat: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	: # libgnat
	rm -rf $(d_lgnat)
	dh_installdirs -p$(p_lgnat) $(dirs_lgnat)

	for lib in lib{gnat,gnarl}; do \
	  vlib=$$lib-$(GNAT_SONAME); \
	  mv $(d)/$(gcc_lib_dir)/$(rts_subdir)/adalib/$$vlib.so.1 $(d)/$(usr_lib)/. ; \
	  rm -f $(d)/$(gcc_lib_dir)/adalib/$$lib.so.1; \
	done
	$(dh_compat2) dh_movefiles -p$(p_lgnat) $(files_lgnat)

	debian/dh_doclink -p$(p_lgnat) $(p_glbase)

	debian/dh_rmemptydirs -p$(p_lgnat)

	b=libgnat; \
	v=$(GNAT_VERSION); \
	for ext in preinst postinst prerm postrm; do \
	  for t in '' -dev -dbg; do \
	    if [ -f debian/$$b$$t.$$ext ]; then \
	      cp -pf debian/$$b$$t.$$ext debian/$$b$$v$$t.$$ext; \
	    fi; \
	  done; \
	done
	$(cross_makeshlibs) dh_makeshlibs $(ldconfig_arg) -p$(p_lgnat) -V '$(p_lgnat) (>= $(DEB_VERSION))'
	$(call cross_mangle_shlibs,$(p_lgnat))

ifneq (,$(filter $(build_type), build-native cross-build-native))
	mkdir -p $(d_lgnat)/usr/share/lintian/overrides
	cp -p debian/$(p_lgnat).overrides \
		$(d_lgnat)/usr/share/lintian/overrides/$(p_lgnat)
endif

	dh_strip -p$(p_lgnat) --dbg-package=$(p_lgnat_dbg)
	$(cross_shlibdeps) dh_shlibdeps -p$(p_lgnat) \
		$(call shlibdirs_to_search, \
			$(subst gnat-$(GNAT_SONAME),gcc$(GCC_SONAME),$(p_lgnat)) \
		,) \
		$(if $(filter yes, $(with_common_libs)),,-- -Ldebian/shlibs.common$(2))
	$(call cross_mangle_substvars,$(p_lgnat))

	: # $(p_lgnat_dbg)
	debian/dh_doclink -p$(p_lgnat_dbg) $(p_glbase)

	echo $(p_lgnat) $(p_lgnat_dbg) >> debian/$(lib_binaries)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)


$(binary_stamp)-libgnatvsn: $(install_stamp)
	: # $(p_lgnatvsn_dev)
ifneq (,$(filter $(build_type), build-native cross-build-native))
	$(dh_compat2) dh_movefiles -p$(p_lgnatvsn_dev) usr/lib/ada/adalib/gnatvsn
	$(dh_compat2) dh_movefiles -p$(p_lgnatvsn_dev) usr/share/ada/adainclude/gnatvsn
	dh_install -p$(p_lgnatvsn_dev) \
	   debian/gnatvsn.gpr usr/share/ada/adainclude
else
	mkdir -p $(d_lgnatvsn_dev)/$(gcc_lib_dir)/{adalib,adainclude}/gnatvsn
	mv $(d)/usr/lib/ada/adalib/gnatvsn $(d_lgnatvsn_dev)/$(gcc_lib_dir)/adalib/.
	mv $(d)/usr/share/ada/adainclude/gnatvsn $(d_lgnatvsn_dev)/$(gcc_lib_dir)/adainclude/.
	dh_install -p$(p_lgnatvsn_dev) \
	   debian/gnatvsn.gpr $(gcc_lib_dir)/adainclude
endif
	$(dh_compat2) dh_movefiles -p$(p_lgnatvsn_dev) $(usr_lib)/libgnatvsn.a
	dh_link -p$(p_lgnatvsn_dev) \
	   $(usr_lib)/libgnatvsn.so.$(GNAT_VERSION) \
	   $(usr_lib)/libgnatvsn.so
	debian/dh_doclink -p$(p_lgnatvsn_dev) $(p_glbase)
	dh_strip -p$(p_lgnatvsn_dev) -X.a --keep-debug

	: # $(p_lgnatvsn)
ifneq (,$(filter $(build_type), build-native cross-build-native))
	mkdir -p $(d_lgnatvsn)/usr/share/lintian/overrides
	cp -p debian/$(p_lgnatvsn).overrides \
		$(d_lgnatvsn)/usr/share/lintian/overrides/$(p_lgnatvsn)
endif
	$(dh_compat2) dh_movefiles -p$(p_lgnatvsn) $(usr_lib)/libgnatvsn.so.$(GNAT_VERSION)
	debian/dh_doclink -p$(p_lgnatvsn) $(p_glbase)
	dh_strip -p$(p_lgnatvsn) --dbg-package=$(p_lgnatvsn_dbg)
	$(cross_makeshlibs) dh_makeshlibs $(ldconfig_arg) -p$(p_lgnatvsn) \
		-V '$(p_lgnatvsn) (>= $(DEB_VERSION))'
	$(call cross_mangle_shlibs,$(p_lgnatvsn))
	cat debian/$(p_lgnatvsn)/DEBIAN/shlibs >> debian/shlibs.local
	$(cross_shlibdeps) dh_shlibdeps -p$(p_lgnatvsn) \
		$(call shlibdirs_to_search, \
			$(subst gnatvsn$(GNAT_SONAME),gcc$(GCC_SONAME),$(p_lgnatvsn)) \
			$(subst gnatvsn$(GNAT_SONAME),gnat-$(GNAT_SONAME),$(p_lgnatvsn)) \
		,) \
		$(if $(filter yes, $(with_common_libs)),,-- -Ldebian/shlibs.common$(2))
	$(call cross_mangle_substvars,$(p_lgnatvsn))

	: # $(p_lgnatvsn_dbg)
	debian/dh_doclink -p$(p_lgnatvsn_dbg) $(p_glbase)

	echo $(p_lgnatvsn) $(p_lgnatvsn_dev) $(p_lgnatvsn_dbg) >> debian/$(lib_binaries)
	touch $@

$(binary_stamp)-libgnatprj: $(install_stamp)
	: # $(p_lgnatprj_dev)
ifneq (,$(filter $(build_type), build-native cross-build-native))
	$(dh_compat2) dh_movefiles -p$(p_lgnatprj_dev) usr/lib/ada/adalib/gnatprj
	$(dh_compat2) dh_movefiles -p$(p_lgnatprj_dev) usr/share/ada/adainclude/gnatprj
	dh_install -p$(p_lgnatprj_dev) \
	   debian/gnatprj.gpr usr/share/ada/adainclude
else
	mkdir -p $(d_lgnatprj_dev)/$(gcc_lib_dir)/{adalib,adainclude}/gnatvsn
	mv $(d)/usr/lib/ada/adalib/gnatprj $(d_lgnatprj_dev)/$(gcc_lib_dir)/adalib/.
	mv $(d)/usr/share/ada/adainclude/gnatprj $(d_lgnatprj_dev)/$(gcc_lib_dir)/adainclude/.
	dh_install -p$(p_lgnatprj_dev) \
	   debian/gnatprj.gpr $(gcc_lib_dir)/adainclude
endif
	$(dh_compat2) dh_movefiles -p$(p_lgnatprj_dev) $(usr_lib)/libgnatprj.a
	dh_link -p$(p_lgnatprj_dev) \
	   $(usr_lib)/libgnatprj.so.$(GNAT_VERSION) \
	   $(usr_lib)/libgnatprj.so
	dh_strip -p$(p_lgnatprj_dev) -X.a --keep-debug
	debian/dh_doclink -p$(p_lgnatprj_dev) $(p_glbase)

	: # $(p_lgnatprj)
ifneq (,$(filter $(build_type), build-native cross-build-native))
	mkdir -p $(d_lgnatprj)/usr/share/lintian/overrides
	cp -p debian/$(p_lgnatprj).overrides \
		$(d_lgnatprj)/usr/share/lintian/overrides/$(p_lgnatprj)
endif
	$(dh_compat2) dh_movefiles -p$(p_lgnatprj) $(usr_lib)/libgnatprj.so.$(GNAT_VERSION)
	debian/dh_doclink -p$(p_lgnatprj) $(p_glbase)
	dh_strip -p$(p_lgnatprj) --dbg-package=$(p_lgnatprj_dbg)
	$(cross_makeshlibs) dh_makeshlibs $(ldconfig_arg) -p$(p_lgnatprj) \
		-V '$(p_lgnatprj) (>= $(DEB_VERSION))'
	$(call cross_mangle_shlibs,$(p_lgnatprj))
	cat debian/$(p_lgnatprj)/DEBIAN/shlibs >> debian/shlibs.local
	$(cross_shlibdeps) dh_shlibdeps -p$(p_lgnatprj) \
		$(call shlibdirs_to_search, \
			$(subst gnatprj$(GNAT_SONAME),gcc$(GCC_SONAME),$(p_lgnatprj)) \
			$(subst gnatprj$(GNAT_SONAME),gnat-$(GNAT_SONAME),$(p_lgnatprj)) \
			$(subst gnatprj$(GNAT_SONAME),gnatvsn$(GNAT_SONAME),$(p_lgnatprj)) \
		,) \
		$(if $(filter yes, $(with_common_libs)),,-- -Ldebian/shlibs.common$(2))
	$(call cross_mangle_substvars,$(p_lgnatprj))

	: # $(p_lgnatprj_dbg)
	debian/dh_doclink -p$(p_lgnatprj_dbg) $(p_glbase)

	echo $(p_lgnatprj) $(p_lgnatprj_dev) $(p_lgnatprj_dbg) >> debian/$(lib_binaries)
	touch $@

$(binary_stamp)-ada: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp
	: # $(p_gnat)
	rm -rf $(d_gnat)
	dh_installdirs -p$(p_gnat) $(dirs_gnat)
	: # Upstream does not install gnathtml.
	cp src/gcc/ada/gnathtml.pl debian/tmp/$(PF)/bin/$(cmd_prefix)gnathtml$(pkg_ver)
	chmod 755 debian/tmp/$(PF)/bin/$(cmd_prefix)gnathtml$(pkg_ver)
	$(dh_compat2) dh_movefiles -p$(p_gnat) $(files_gnat)

ifeq ($(with_gnatsjlj),yes)
	dh_installdirs -p$(p_gnatsjlj) $(gcc_lib_dir)
	$(dh_compat2) dh_movefiles -p$(p_gnatsjlj) $(gcc_lib_dir)/rts-sjlj/adalib $(gcc_lib_dir)/rts-sjlj/adainclude
endif

ifeq ($(with_libgnat),yes)
	for lib in lib{gnat,gnarl}; do \
	  vlib=$$lib-$(GNAT_SONAME); \
	  dh_link -p$(p_gnat) \
	    /$(usr_lib)/$$vlib.so.1 /$(usr_lib)/$$vlib.so \
	    /$(usr_lib)/$$vlib.so.1 /$(usr_lib)/$$lib.so; \
	done
	for lib in lib{gnat,gnarl}; do \
	  vlib=$$lib-$(GNAT_SONAME); \
	  dh_link -p$(p_gnat) \
	    /$(usr_lib)/$$vlib.so.1 $(gcc_lib_dir)/$(rts_subdir)adalib/$$lib.so; \
	done
endif
	debian/dh_doclink -p$(p_gnat)      $(p_gbase)
ifeq ($(with_gnatsjlj),yes)
	debian/dh_doclink -p$(p_gnatsjlj) $(p_gbase)
endif
ifeq ($(PKGSOURCE),gnat-$(BASE_VERSION))
  ifeq ($(with_check),yes)
	cp -p test-summary $(d_gnat)/$(docdir)/$(p_gbase)/.
  endif
else
	mkdir -p $(d_gnat)/$(docdir)/$(p_gbase)/ada
	cp -p src/gcc/ada/ChangeLog $(d_gnat)/$(docdir)/$(p_gbase)/ada/.
endif

	for i in $(GNAT_TOOLS); do \
	  case "$$i" in \
	    gnat) cp -p debian/gnat.1 $(d_gnat)/$(PF)/share/man/man1/$(cmd_prefix)gnat$(pkg_ver).1 ;; \
	    *) ln -sf $(cmd_prefix)gnat$(pkg_ver).1 $(d_gnat)/$(PF)/share/man/man1/$(cmd_prefix)$$i$(pkg_ver).1; \
	  esac; \
	done

ifneq (,$(filter $(build_type), build-native cross-build-native))
	: # ship the versioned prefixed names in the gnat package.
	for i in $(GNAT_TOOLS); do \
	  ln -sf $$i$(pkg_ver) \
	    $(d_gnat)/$(PF)/bin/$(DEB_TARGET_GNU_TYPE)-$$i$(pkg_ver); \
	  ln -sf $$i$(pkg_ver) \
	    $(d_gnat)/$(PF)/bin/$(TARGET_ALIAS)-$$i$(pkg_ver); \
	  ln -sf gnat$(pkg_ver).1 \
	    $(d_gnat)/$(PF)/share/man/man1/$(DEB_TARGET_GNU_TYPE)-$$i$(pkg_ver).1; \
	  ln -sf $$i$(pkg_ver).1 \
	    $(d_gnat)/$(PF)/share/man/man1/$(TARGET_ALIAS)-$$i$(pkg_ver).1; \
	done

	: # still ship the unversioned names in the gnat package.
	for i in $(GNAT_TOOLS); do \
	  ln -sf $$i$(pkg_ver) \
	    $(d_gnat)/$(PF)/bin/$$i; \
	  ln -sf $$i$(pkg_ver) \
	    $(d_gnat)/$(PF)/bin/$$i; \
	  ln -sf gnat$(pkg_ver).1 \
	    $(d_gnat)/$(PF)/share/man/man1/$$i.1; \
	  ln -sf $$i$(pkg_ver).1 \
	    $(d_gnat)/$(PF)/share/man/man1/$$i.1; \
	done

	: # still ship the unversioned prefixed names in the gnat package.
	for i in $(GNAT_TOOLS); do \
	  ln -sf $$i$(pkg_ver) \
	    $(d_gnat)/$(PF)/bin/$(DEB_TARGET_GNU_TYPE)-$$i; \
	  ln -sf $$i$(pkg_ver) \
	    $(d_gnat)/$(PF)/bin/$(TARGET_ALIAS)-$$i; \
	  ln -sf gnat$(pkg_ver).1 \
	    $(d_gnat)/$(PF)/share/man/man1/$(DEB_TARGET_GNU_TYPE)-$$i.1; \
	  ln -sf $$i$(pkg_ver).1 \
	    $(d_gnat)/$(PF)/share/man/man1/$(TARGET_ALIAS)-$$i.1; \
	done
else
	: # still ship the unversioned names in the gnat package.
	for i in $(GNAT_TOOLS); do \
	  ln -sf $(DEB_TARGET_GNU_TYPE)-$$i$(pkg_ver) \
	    $(d_gnat)/$(PF)/bin/$(DEB_TARGET_GNU_TYPE)-$$i; \
	  ln -sf $(DEB_TARGET_GNU_TYPE)-$$i$(pkg_ver) \
	    $(d_gnat)/$(PF)/bin/$(TARGET_ALIAS)-$$i; \
	  ln -sf $(DEB_TARGET_GNU_TYPE)-gnat$(pkg_ver).1 \
	    $(d_gnat)/$(PF)/share/man/man1/$(DEB_TARGET_GNU_TYPE)-$$i.1; \
	  ln -sf $(DEB_TARGET_GNU_TYPE)-$$i$(pkg_ver).1 \
	    $(d_gnat)/$(PF)/share/man/man1/$(TARGET_ALIAS)-$$i.1; \
	done
endif

ifneq (,$(filter $(build_type), build-native cross-build-native))
	dh_install -p$(p_gnat) debian/ada/debian_packaging.mk usr/share/ada
	mv $(d_gnat)/usr/share/ada/debian_packaging.mk \
	    $(d_gnat)/usr/share/ada/debian_packaging-$(GNAT_VERSION).mk
endif
	: # keep this one unversioned, see Debian #802838.
	dh_link -p$(p_gnat) usr/bin/$(cmd_prefix)gcc$(pkg_ver) usr/bin/$(cmd_prefix)gnatgcc
	dh_link -p$(p_gnat) usr/share/man/man1/$(cmd_prefix)gcc$(pkg_ver).1.gz usr/share/man/man1/$(cmd_prefix)gnatgcc.1.gz

	debian/dh_rmemptydirs -p$(p_gnat)

	dh_strip -p$(p_gnat)
	find $(d_gnat) -name '*.ali' | xargs chmod 444
	$(cross_shlibdeps) dh_shlibdeps -p$(p_gnat) \
		$(call shlibdirs_to_search, \
			$(p_lgcc) $(p_lgnat) $(p_lgnatvsn) $(p_lgnatprj) \
		,)
	echo $(p_gnat) >> debian/arch_binaries

ifeq ($(with_gnatsjlj),yes)
	dh_strip -p$(p_gnatsjlj)
	find $(d_gnatsjlj) -name '*.ali' | xargs chmod 444
	$(cross_makeshlibs) dh_shlibdeps -p$(p_gnatsjlj)
	echo $(p_gnatsjlj) >> debian/arch_binaries
endif

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)


$(build_gnatdoc_stamp): $(build_stamp)
	mkdir -p html
	rm -f html/*.info
	echo -n gnat_ugn gnat_rm gnat-style | xargs -d ' ' -L 1 -P $(USE_CPUS) -I{} \
	  sh -c 'cd html && \
	    echo "generating {}-$(GNAT_VERSION).info"; \
	    makeinfo -I $(srcdir)/gcc/doc/include -I $(srcdir)/gcc/ada \
		-I $(builddir)/gcc \
		-o {}-$(GNAT_VERSION).info \
		$(srcdir)/gcc/ada/{}.texi'
	touch $@

$(binary_stamp)-ada-doc: $(build_html_stamp) $(build_gnatdoc_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_gnatd)
	dh_installdirs -p$(p_gnatd) \
		$(PF)/share/info
	cp -p html/gnat*info* $(d_gnatd)/$(PF)/share/info/.
	dh_installdocs -p$(p_gnatd) \
	    html/gnat_ugn.html html/gnat_rm.html html/gnat-style.html
	echo $(p_gnatd) >> debian/indep_binaries

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
