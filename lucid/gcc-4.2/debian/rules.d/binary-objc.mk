ifneq (,$(filter yes, $(biarch) $(biarch32)))
  arch_binaries  := $(arch_binaries) objc-multi
endif
arch_binaries := $(arch_binaries) objc

p_objc	= gobjc$(pkg_ver)
d_objc	= debian/$(p_objc)

p_objc_m= gobjc$(pkg_ver)-multilib
d_objc_m= debian/$(p_objc_m)

dirs_objc = \
	$(docdir)/$(p_base)/ObjC \
	$(gcc_lexec_dir) \
	$(gcc_lib_dir)/include

files_objc = \
	$(gcc_lexec_dir)/cc1obj \
	$(gcc_lib_dir)/include/objc \
	$(gcc_lib_dir)/libobjc*.a

$(binary_stamp)-objc: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -f $(d)/$(PF)/$(libdir)/libobjc.{la,so}
	mv $(d)/$(PF)/$(libdir)/libobjc*.a $(d)/$(gcc_lib_dir)/

	rm -rf $(d_objc)
	dh_installdirs -p$(p_objc) $(dirs_objc)
	DH_COMPAT=2 dh_movefiles -p$(p_objc) $(files_objc)

	dh_link -p$(p_objc) \
	  /$(PF)/$(libdir)/libobjc.so.$(OBJC_SONAME) /$(gcc_lib_dir)/libobjc.so
ifeq ($(with_objc_gc),yes)
	dh_link -p$(p_objc) \
	  /$(PF)/$(libdir)/libobjc_gc.so.$(OBJC_SONAME) \
	  /$(gcc_lib_dir)/libobjc_gc.so
endif

	debian/dh_doclink -p$(p_objc) $(p_base)
	cp -p $(srcdir)/libobjc/{README*,THREADS*} \
		$(d_objc)/$(docdir)/$(p_base)/ObjC/.

	cp -p $(srcdir)/libobjc/ChangeLog \
		$(d_objc)/$(docdir)/$(p_base)/ObjC/changelog.libobjc

	debian/dh_rmemptydirs -p$(p_objc)

	dh_strip -p$(p_objc)
	dh_compress -p$(p_objc)

	dh_fixperms -p$(p_objc)
	dh_shlibdeps -p$(p_objc)
	dh_gencontrol -p$(p_objc) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_objc)
	dh_md5sums -p$(p_objc)
	dh_builddeb -p$(p_objc)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

$(binary_stamp)-objc-multi: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_objc_m)
	dh_installdirs -p$(p_objc_m) \
		$(docdir) \
		$(gcc_lib_dir)/$(biarchsubdir)

ifeq ($(biarch),yes)
	rm -f $(d)/$(PF)/lib64/libobjc*.{la,so}
	mkdir -p $(d_objc_m)/$(gcc_lib_dir)/$(biarchsubdir)
	mv $(d)/$(PF)/lib64/libobjc*.a $(d_objc_m)/$(gcc_lib_dir)/$(biarchsubdir)/
	dh_link -p$(p_objc_m) \
	  /$(PF)/lib64/libobjc.so.$(OBJC_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libobjc.so
  ifeq ($(with_objc_gc),yes)
	dh_link -p$(p_objc_m) \
	  /$(PF)/lib64/libobjc_gc.so.$(OBJC_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libobjc_gc.so
  endif
endif
ifeq ($(biarch32),yes)
	rm -f $(d)/$(lib32)/libobjc*.{la,so}
	mkdir -p $(d_objc_m)/$(gcc_lib_dir)/$(biarchsubdir)
	mv $(d)/$(lib32)/libobjc*.a $(d_objc_m)/$(gcc_lib_dir)/$(biarchsubdir)/
	dh_link -p$(p_objc_m) \
	  /$(lib32)/libobjc.so.$(OBJC_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libobjc.so
  ifeq ($(with_objc_gc),yes)
	dh_link -p$(p_objc_m) \
	  /$(lib32)/libobjc_gc.so.$(OBJC_SONAME) /$(gcc_lib_dir)/$(biarchsubdir)/libobjc_gc.so
  endif
endif

	debian/dh_doclink -p$(p_objc_m) $(p_base)

	dh_strip -p$(p_objc_m)
	dh_compress -p$(p_objc_m)

	dh_fixperms -p$(p_objc_m)
	dh_shlibdeps -p$(p_objc_m)
	dh_gencontrol -p$(p_objc_m) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_objc_m)
	dh_md5sums -p$(p_objc_m)
	dh_builddeb -p$(p_objc_m)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
