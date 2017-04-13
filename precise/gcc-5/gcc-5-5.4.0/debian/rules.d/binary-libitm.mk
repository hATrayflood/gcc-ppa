$(lib_binaries)  += libitm
ifeq ($(with_lib64itm),yes)
  $(lib_binaries)  += lib64itm
endif
ifeq ($(with_lib32itm),yes)
  $(lib_binaries)	+= lib32itm
endif
ifeq ($(with_libn32itm),yes)
  $(lib_binaries)	+= libn32itm
endif
ifeq ($(with_libx32itm),yes)
  $(lib_binaries)	+= libx32itm
endif
ifeq ($(with_libhfitm),yes)
  $(lib_binaries)	+= libhfitm
endif
ifeq ($(with_libsfitm),yes)
  $(lib_binaries)	+= libsfitm
endif

define __do_itm
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_l) $(d_d)
	dh_installdirs -p$(p_l) $(usr_lib$(2))
	$(dh_compat2) dh_movefiles -p$(p_l) $(usr_lib$(2))/libitm.so.*

	debian/dh_doclink -p$(p_l) $(p_lbase)
	debian/dh_doclink -p$(p_d) $(p_lbase)

	dh_strip -p$(p_l) --dbg-package=$(p_d)
	ln -sf libitm.symbols debian/$(p_l).symbols
	$(cross_makeshlibs) dh_makeshlibs $(ldconfig_arg) -p$(p_l)
	$(call cross_mangle_shlibs,$(p_l))
	$(ignshld)DIRNAME=$(subst n,,$(2)) $(cross_shlibdeps) dh_shlibdeps -p$(p_l) \
		$(call shlibdirs_to_search,,$(2))
	$(call cross_mangle_substvars,$(p_l))
	echo $(p_l) $(p_d) >> debian/$(lib_binaries)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
endef

# ----------------------------------------------------------------------

do_itm = $(call __do_itm,lib$(1)itm$(ITM_SONAME),$(1))

$(binary_stamp)-libitm: $(install_stamp)
	$(call do_itm,)

$(binary_stamp)-lib64itm: $(install_stamp)
	$(call do_itm,64)

$(binary_stamp)-lib32itm: $(install_stamp)
	$(call do_itm,32)

$(binary_stamp)-libn32itm: $(install_stamp)
	$(call do_itm,n32)

$(binary_stamp)-libx32itm: $(install_stamp)
	$(call do_itm,x32)

$(binary_stamp)-libhfitm: $(install_dependencies)
	$(call do_itm,hf)

$(binary_stamp)-libsfitm: $(install_dependencies)
	$(call do_itm,sf)
