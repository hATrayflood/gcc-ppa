ifneq ($(DEB_STAGE),rtlibs)
  ifneq (,$(filter yes, $(biarch64) $(biarch32) $(biarchn32) $(biarchx32) $(biarchsf)))
    arch_binaries  := $(arch_binaries) gdc-multi
  endif
  arch_binaries := $(arch_binaries) gdc

  ifeq ($(with_libphobos),yes)
    $(lib_binaries) += libphobos-dev
  endif

  ifeq ($(with_lib64phobosdev),yes)
    $(lib_binaries)	+= lib64phobos-dev
  endif
  ifeq ($(with_lib32phobosdev),yes)
    $(lib_binaries)	+= lib32phobos-dev
  endif
  ifeq ($(with_libn32phobosdev),yes)
    $(lib_binaries)	+= libn32phobos-dev
  endif
  ifeq ($(with_libx32phobosdev),yes)
    $(lib_binaries)	+= libx32phobos-dev
  endif
  ifeq ($(with_libhfphobosdev),yes)
    $(lib_binaries)	+= libhfphobos-dev
  endif
  ifeq ($(with_libsfphobosdev),yes)
    $(lib_binaries)	+= libsfphobos-dev
  endif

  ifeq (0,1)
  ifeq ($(with_lib64phobos),yes)
    $(lib_binaries)	+= lib64phobos
  endif
  ifeq ($(with_lib32phobos),yes)
    $(lib_binaries)	+= lib32phobos
  endif
  ifeq ($(with_libn32phobos),yes)
    $(lib_binaries)	+= libn32phobos
  endif
  ifeq ($(with_libx32phobos),yes)
    $(lib_binaries)	+= libx32phobos
  endif
  ifeq ($(with_libhfphobos),yes)
    $(lib_binaries)	+= libhfphobos
  endif
  ifeq ($(with_libsfphobos),yes)
    $(lib_binaries)	+= libsfphobos
  endif
  endif
endif

p_gdc           = gdc$(pkg_ver)$(cross_bin_arch)
p_gdc_m		= gdc$(pkg_ver)-multilib$(cross_bin_arch)
p_libphobos     = libphobos$(pkg_ver)-dev

d_gdc           = debian/$(p_gdc)
d_gdc_m		= debian/$(p_gdc_m)
d_libphobos     = debian/$(p_libphobos)

ifeq ($(DEB_CROSS),yes)
  gdc_include_dir := $(gcc_lib_dir)/include/d
else
  gdc_include_dir := $(PF)/include/d/$(BASE_VERSION)
endif
# FIXME: always here?
gdc_include_dir := $(gcc_lib_dir)/include/d

dirs_gdc = \
	$(PF)/bin \
	$(PF)/share/man/man1 \
	$(gcc_lexec_dir)
ifneq ($(DEB_CROSS),yes)
  dirs_gdc += \
	$(gdc_include_dir)
endif

files_gdc = \
	$(PF)/bin/$(cmd_prefix)gdc$(pkg_ver) \
	$(gcc_lexec_dir)/cc1d
ifneq ($(GFDL_INVARIANT_FREE),yes-now-pure-gfdl)
    files_gdc += \
	$(PF)/share/man/man1/$(cmd_prefix)gdc$(pkg_ver).1
endif

dirs_libphobos = \
	$(PF)/lib \
	$(gdc_include_dir) \
	$(gcc_lib_dir)

$(binary_stamp)-gdc: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_gdc)
	dh_installdirs -p$(p_gdc) $(dirs_gdc)

	dh_installdocs -p$(p_gdc) src/gcc/d/README
	dh_installchangelogs -p$(p_gdc) src/gcc/d/ChangeLog

	$(dh_compat2) dh_movefiles -p$(p_gdc) -X/zlib/ $(files_gdc)

ifneq ($(DEB_CROSS),yes)
	ln -sf gdc$(pkg_ver) \
	    $(d_gdc)/$(PF)/bin/$(DEB_TARGET_GNU_TYPE)-gdc$(pkg_ver)
	ln -sf gdc$(pkg_ver) \
	    $(d_gdc)/$(PF)/bin/$(TARGET_ALIAS)-gdc$(pkg_ver)
  ifneq ($(GFDL_INVARIANT_FREE),yes-now-pure-gfdl)
	ln -sf gdc$(pkg_ver).1 \
	    $(d_gdc)/$(PF)/share/man/man1/$(DEB_TARGET_GNU_TYPE)-gdc$(pkg_ver).1
	ln -sf gdc$(pkg_ver).1 \
	    $(d_gdc)/$(PF)/share/man/man1/$(TARGET_ALIAS)-gdc$(pkg_ver).1
  endif
endif

# FIXME: __entrypoint.di needs to go into a libgdc-dev Multi-Arch: same package
	# Always needed by gdc.
	mkdir -p $(d_gdc)/$(gdc_include_dir)
	cp $(srcdir)/libphobos/libdruntime/__entrypoint.di \
	    $(d_gdc)/$(gdc_include_dir)/.
#ifneq ($(DEB_CROSS),yes)
#	dh_link -p$(p_gdc) \
#		/$(gdc_include_dir) \
#		/$(dir $(gdc_include_dir))/$(GCC_VERSION)
#endif

	dh_link -p$(p_gdc) \
		/$(docdir)/$(p_gcc)/README.Bugs \
		/$(docdir)/$(p_gdc)/README.Bugs

	dh_strip -p$(p_gdc) \
	  $(if $(unstripped_exe),-X/cc1d)
	dh_shlibdeps -p$(p_gdc)
	echo $(p_gdc) >> debian/arch_binaries

	find $(d_gdc) -type d -empty -delete

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

$(binary_stamp)-gdc-multi: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_gdc_m)
	dh_installdirs -p$(p_gdc_m) $(docdir)

	debian/dh_doclink -p$(p_gdc_m) $(p_xbase)

	dh_strip -p$(p_gdc_m)
	dh_shlibdeps -p$(p_gdc_m)
	echo $(p_gdc_m) >> debian/arch_binaries

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

$(binary_stamp)-libphobos: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_libphobos)
	dh_installdirs -p$(p_libphobos) $(dirs_libphobos)

	mv $(d)/$(usr_lib)/libg{druntime,phobos2}.a \
		$(d)/$(gcc_lib_dir)/.
	$(dh_compat2) dh_movefiles -p$(p_libphobos) \
		$(gcc_lib_dir)/libg{druntime,phobos2}.a

	# included in gdc package
	rm -f $(d_libphobos)/$(gdc_include_dir)/__entrypoint.di

ifeq ($(with_separate_gdc),yes)
	debian/dh_doclink -p$(p_libphobos) $(p_gdc)
else
	debian/dh_doclink -p$(p_libphobos) $(p_lbase)
endif

	dh_strip -p$(p_libphobos)
	dh_shlibdeps -p$(p_libphobos)
	echo $(p_libphobos) >> debian/arch_binaries

	find $(d_libphobos) -type d -empty -delete

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

define __do_libphobos_dev
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_l)
	dh_installdirs -p$(p_l) \
		$(gcc_lib_dir$(2))
	mv $(d)/$(usr_lib$(2))/libg{druntime,phobos2}.a \
		$(d)/$(gcc_lib_dir$(2))/.
	$(dh_compat2) dh_movefiles -p$(p_l) \
		$(gcc_lib_dir$(2))/libg{druntime,phobos2}.a
	$(if $(2),,
	$(dh_compat2) dh_movefiles -p$(p_l) \
		$(gdc_include_dir)
	)

	: # included in gdc package
	rm -f $(d_l)/$(gdc_include_dir)/__entrypoint.di

	debian/dh_doclink -p$(p_l) \
		$(if $(filter yes,$(with_separate_gdc)),$(p_gdc),$(p_lbase))
	echo $(p_l) >> debian/$(lib_binaries)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
endef

# don't put this as a comment within define/endef
#	$(call install_gcc_lib,libphobos,$(PHOBOS_SONAME),$(2),$(p_l))

do_libphobos_dev = $(call __do_libphobos_dev,lib$(1)phobos-$(BASE_VERSION)-dev,$(1))

$(binary_stamp)-libphobos-dev: $(install_stamp)
	$(call do_libphobos_dev,)

$(binary_stamp)-lib64phobos-dev: $(install_stamp)
	$(call do_libphobos_dev,64)

$(binary_stamp)-lib32phobos-dev: $(install_stamp)
	$(call do_libphobos_dev,32)

$(binary_stamp)-libx32phobos-dev: $(install_stamp)
	$(call do_libphobos_dev,x32)

$(binary_stamp)-libn32phobos-dev: $(install_stamp)
	$(call do_libphobos_dev,n32)

$(binary_stamp)-libhfphobos-dev: $(install_stamp)
	$(call do_libphobos_dev,hf)

$(binary_stamp)-libsfphobos-dev: $(install_stamp)
	$(call do_libphobos_dev,sf)
