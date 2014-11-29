ifeq ($(with_gcj),yes)
    arch_binaries  := $(arch_binaries) jbase gcj
endif

ifeq ($(with_libgcj),yes)
  ifeq ($(with_java),yes)
    arch_binaries  := $(arch_binaries) java
    indep_binaries  := $(indep_binaries) libgcjjar
  endif

  #ifeq ($(with_common_libs),yes)
  #  indep_binaries  := $(indep_binaries) libgcj-common
  #endif

  ifeq ($(with_javadev),yes)
    arch_binaries  := $(arch_binaries) libgcjdev libgcjdbg
    indep_binaries := $(indep_binaries) libgcjsrc
  endif

  ifeq ($(with_java32),yes)
    arch_binaries  := $(arch_binaries) java32
  endif
endif

p_jbase	= gcj$(pkg_ver)-base
p_gcj	= gcj$(pkg_ver)
p_gij	= gij$(pkg_ver)
p_jcom	= libgcj-common
p_jlib	= libgcj$(GCJ_SONAME)
p_jdbg	= libgcj$(GCJ_SONAME)-dbg
p_jar	= libgcj$(GCJ_SONAME)-jar
p_jlibx	= libgcj$(GCJ_SONAME)-awt
p_jdev	= libgcj$(GCJ_SONAME)-dev
p_jsrc	= libgcj$(GCJ_SONAME)-src
p_j32lib= lib32gcj$(GCJ_SONAME)
p_j32dev= lib32gcj$(GCJ_SONAME)-dev
p_j32dbg= lib32gcj$(GCJ_SONAME)-dbg

d_jbase	= debian/$(p_jbase)
d_gcj	= debian/$(p_gcj)
d_gij	= debian/$(p_gij)
d_jcom	= debian/$(p_jcom)
d_jlib	= debian/$(p_jlib)
d_jdbg	= debian/$(p_jdbg)
d_jar	= debian/$(p_jar)
d_jlibx	= debian/$(p_jlibx)
d_jdev	= debian/$(p_jdev)
d_jsrc	= debian/$(p_jsrc)
d_j32lib= debian/$(p_j32lib)
d_j32dev= debian/$(p_j32dev)
d_j32dbg= debian/$(p_j32dbg)

dirs_gcj = \
	$(docdir)/$(p_jbase) \
	$(PF)/bin \
	$(PF)/share/man/man1 \
	$(PF)/share/info \
	$(gcc_lexec_dir)
files_gcj = \
	$(PF)/bin/{gcj,gcjh,gjnih,jv-convert,jv-scan,jcf-dump,grmic}$(pkg_ver) \
	$(PF)/share/man/man1/{gcj,gcjh,gjnih,jv-convert,jv-scan,jcf-dump,grmic}$(pkg_ver).1 \
	$(gcc_lexec_dir)/{jc1,jvgenmain}

ifneq ($(GFDL_INVARIANT_FREE),yes)
  files_gcj += \
	$(PF)/share/info/gcj*
endif

ifeq ($(with_standalone_gcj),yes)
  dirs_gcj += $(gcc_lib_dir)
  files_gcj += \
	$(gcc_lexec_dir)/collect2 \
	$(gcc_lib_dir)/{libgcc*,*.o}
  ifeq ($(biarch),yes)
    files_gcc += $(gcc_lib_dir)/64/{libgcc*,*.o}
  endif
  ifeq ($(biarch32),yes)
    files_gcc += $(gcc_lib_dir)/32/{libgcc*,*.o}
  endif
endif

dirs_gij = \
	$(docdir)/$(p_jbase) \
	$(PF)/bin \
	$(PF)/share/man/man1 \
	var/lib/gcj$(pkg_ver)

files_gij = \
	$(PF)/bin/{gij,gcj-dbtool,grmiregistry}$(pkg_ver) \
	$(PF)/share/man/man1/{gij,gcj-dbtool,grmiregistry}$(pkg_ver).1

dirs_jcom = \
	$(PF)/$(libdir)

files_jcom = \
	$(PF)/lib/security

dirs_jlib = \
	$(docdir)/$(p_jbase) \
	$(PF)/$(libdir)/gcj$(pkg_ver) \
	$(PF)/$(libdir)

files_jlib = \
	$(PF)/$(libdir)/libgij.so.* \
	$(PF)/$(libdir)/libgcj.so.*

dirs_jar = \
	$(PF)/share/java

dirs_jlibx = \
	$(PF)/$(libdir) \
	$(PF)/$(libdir)/gcj$(pkg_ver) \
	$(PF)/share/java

files_jlibx = \
	$(PF)/$(libdir)/libgcjawt.so.* \
	$(PF)/$(libdir)/lib-gnu-java-awt*.so.*

dirs_jdev = \
	$(docdir)/$(p_jbase)/examples \
	$(PF)/{include,lib} \
	$(gcc_lib_dir)/include/gcj

files_jdev = \
	$(cxx_inc_dir)/{org,gcj,java,javax} \
	$(cxx_inc_dir)/gnu/{awt,classpath,gcj,java,javax,regexp} \
	$(gcc_lib_dir)/include/{jni.h,jvmpi.h} \
	$(gcc_lib_dir)/include/{jawt.h,jawt_md.h} \
	$(gcc_lib_dir)/include/gcj/libgcj-config.h \
	$(PF)/$(libdir)/libgij*.{a,la,so} \
	$(PF)/$(libdir)/libgcj*.{a,la} \
	$(PF)/$(libdir)/{libgcj*.so,libgcj.spec} \
	$(PF)/$(libdir)/pkgconfig/libgcj.pc \
	$(PF)/$(libdir)/lib-gnu-*.{a,la} \
	$(PF)/$(libdir)/lib-gnu-*.so

files_jdev += \
	$(PF)/$(libdir)/libgcjawt.{a,la,so} \

ifeq ($(with_lib64gcj),yes)
	dirs_jlib    +=	$(PF)/$(lib64)
	files_jlib   +=	$(PF)/$(lib64)/libgcj*.so.*

	dirs_jlibx   +=	$(PF)/$(lib64)
	files_jlibx  +=	$(PF)/$(lib64)/lib-gnu-java-awt-*.so.*

	dirs_jdev    += $(PF)/$(lib64)
	files_jdev   += $(PF)/$(lib64)/libgcj*.{a,so,la} \
			$(PF)/$(lib64)/lib-gnu-*.{a,so,la}
endif

# ----------------------------------------------------------------------
$(binary_stamp)-jbase: $(install_dependencies)
	dh_testdir
	dh_testroot
	rm -rf $(d_jbase)
	dh_installdirs -p$(p_jbase)
	dh_installdocs -p$(p_jbase)
	dh_installchangelogs -p$(p_jbase)
	dh_compress -p$(p_jbase)
	dh_fixperms -p$(p_jbase)
	dh_gencontrol -p$(p_jbase) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_jbase)
	dh_md5sums -p$(p_jbase)
	dh_builddeb -p$(p_jbase)
	touch $@

# ----------------------------------------------------------------------
$(binary_stamp)-libgcj-common: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	dh_installdirs -p$(p_jcom) $(dirs_jcom)
	[ -d $(d)/$(PF)/$(libdir)/security ] \
		|| mkdir -p $(d)/$(PF)/$(libdir)/security
	[ -f $(d)/$(PF)/$(libdir)/security/classpath.security ] || \
	  cp $(srcdir)/libjava/java/security/*.security \
	    $(d)/$(PF)/$(libdir)/security/.
	DH_COMPAT=2 dh_movefiles -p$(p_jcom) $(files_jcom)
	debian/dh_doclink -p$(p_jcom) $(p_jbase)
	debian/dh_rmemptydirs -p$(p_jcom)
	dh_compress -p$(p_jcom)
	dh_fixperms -p$(p_jcom)
	dh_gencontrol -p$(p_jcom) -- -v$(DEB_EVERSION) $(common_substvars)
	dh_installdeb -p$(p_jcom)
	dh_md5sums -p$(p_jcom)
	dh_builddeb -p$(p_jcom)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-libgcjjar: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	dh_installdirs -p$(p_jar) $(dirs_jar)
	mv $(d)/$(PF)/share/java/libgcj-$(GCC_VERSION).jar \
		$(d_jar)/$(PF)/share/java/
	ln -sf libgcj-$(GCC_VERSION).jar \
		$(d_jar)/$(PF)/share/java/libgcj$(pkg_ver).jar
	debian/dh_doclink -p$(p_jar) $(p_jbase)
	debian/dh_rmemptydirs -p$(p_jar)
	dh_compress -p$(p_jar)
	dh_fixperms -p$(p_jar)
	dh_gencontrol -p$(p_jar) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_jar)
	dh_md5sums -p$(p_jar)
	dh_builddeb -p$(p_jar)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-libgcjsrc: $(install_stamp)
	dh_testdir
	dh_testroot

	$(MAKE) -C $(buildlibdir)/libjava \
		DESTDIR=$(PWD)/$(d) install-src.zip
	mkdir -p $(d_jsrc)/$(PF)/share/java
	mv $(d)/$(PF)/share/java/src-$(GCC_VERSION).zip \
	   $(d_jsrc)/$(PF)/share/java/libgcj-src-$(GCC_VERSION).zip
	ln -s libgcj-src-$(GCC_VERSION).zip \
		$(d_jsrc)/$(PF)/share/java/libgcj-src$(pkg_ver).zip
	debian/dh_doclink -p$(p_jsrc) $(p_jbase)
	debian/dh_rmemptydirs -p$(p_jsrc)
	dh_compress -p$(p_jsrc)
	dh_fixperms -p$(p_jsrc)
	dh_gencontrol -p$(p_jsrc) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_jsrc)
	dh_md5sums -p$(p_jsrc)
	dh_builddeb -p$(p_jsrc)

	touch $@

# ----------------------------------------------------------------------
$(binary_stamp)-java: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	dh_installdirs -p$(p_gij)   $(dirs_gij)
	dh_installdirs -p$(p_jlib)  $(dirs_jlib)
	dh_installdirs -p$(p_jlibx) $(dirs_jlibx)

	DH_COMPAT=2 dh_movefiles -p$(p_gij)   $(files_gij)
	DH_COMPAT=2 dh_movefiles -p$(p_jlib)  $(files_jlib)
	DH_COMPAT=2 dh_movefiles -p$(p_jlibx) $(files_jlibx)

	cp -p debian/tmp/$(PF)/$(libdir)/libgcjawt.la \
		debian/tmp/$(PF)/$(libdir)/lib-gnu-java-awt*.la \
		$(d_jlibx)/$(PF)/$(libdir)/gcj$(pkg_ver)/

	cp -p $(srcdir)/libjava/{NEWS,README,THANKS} \
		$(d_jlib)/usr/share/doc/$(p_jbase)/
	debian/dh_doclink -p$(p_gij) $(p_jbase)
	debian/dh_doclink -p$(p_jlib) $(p_jbase)
	debian/dh_doclink -p$(p_jlibx) $(p_jbase)

ifeq ($(with_separate_libgcj),yes)
  ifeq ($(PKGSOURCE),gcj-$(BASE_VERSION))
    ifeq ($(with_check),yes)
	cp -p test-summary $(d_gij)/usr/share/doc/$(p_jbase)/test-summary
    endif
  endif
endif
	cp -p debian/gij-wrapper$(pkg_ver) $(d_gij)/$(PF)/bin/
	chmod 755 $(d_gij)/$(PF)/bin/gij-wrapper$(pkg_ver)
	cp -p debian/gij-wrapper$(pkg_ver).1 $(d_gij)/$(PF)/share/man/man1/

	debian/dh_rmemptydirs -p$(p_gij)
	debian/dh_rmemptydirs -p$(p_jlib)
	debian/dh_rmemptydirs -p$(p_jlibx)

	mkdir -p $(d_gij)/var/lib/gcj$(pkg_ver)

	dh_makeshlibs -p$(p_jlib) -V '$(p_jlib) (>= $(DEB_STDCXX_SOVERSION))'
	cat debian/$(p_jlib)/DEBIAN/shlibs >> debian/shlibs.local

	dh_makeshlibs -p$(p_jlibx) -V '$(p_jlibx) (>= $(DEB_GCJ_SOVERSION))'

	DH_COMPAT=5 dh_strip \
		-p$(p_gij) -p$(p_jlib) -p$(p_jlibx) --dbg-package=$(p_jdbg)
	dh_compress -p$(p_gij) -p$(p_jlib) -p$(p_jlibx)
	dh_fixperms -p$(p_gij) -p$(p_jlib) -p$(p_jlibx)
# the libstdc++ binary packages aren't built yet ...
	echo 'libstdc++ $(CXX_SONAME) $(p_lib) (>= $(DEB_STDCXX_SOVERSION))' \
	    >> debian/shlibs.local
	-[ -d $(d_l64gcc) ] && mv $(d_l64gcc) $(d_l64gcc).saved
	dh_shlibdeps \
		-L$(p_lgcc) \
		-L$(p_jlib) \
		-l:$(d)/$(PF)/$(libdir):$(d_lib)/$(PF)/$(libdir):$(d_jlib)/$(PF)/$(libdir):$(d_lgcc)/lib \
		-p$(p_gij) -p$(p_jlib) -p$(p_jlibx)
	-[ -d $(d_l64gcc).saved ] && mv $(d_l64gcc).saved $(d_l64gcc)
	sed -e 's/$(p_jlib)[^,]*//' -e 's/, *,/,/' debian/$(p_jlib).substvars \
		>> debian/$(p_jlib).substvars.tmp \
	    && mv -f debian/$(p_jlib).substvars.tmp debian/$(p_jlib).substvars
	dh_gencontrol \
		-p$(p_gij) -p$(p_jlib) -p$(p_jlibx) \
		-- -v$(DEB_VERSION) $(common_substvars)

	mkdir -p $(d_jlibx)/usr/share/lintian/overrides
	cp -p debian/$(p_jlibx).overrides \
		$(d_jlibx)/usr/share/lintian/overrides/$(p_jlibx)

	dh_installdeb -p$(p_gij) -p$(p_jlib) -p$(p_jlibx)
	dh_md5sums -p$(p_gij) -p$(p_jlib) -p$(p_jlibx)
	dh_builddeb -p$(p_gij) -p$(p_jlib) -p$(p_jlibx)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-gcj: $(build_html_stamp) $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_gcj)
	dh_installdirs -p$(p_gcj)  $(dirs_gcj)

	mkdir -p $(d_gcj)/usr/share/lintian/overrides
	cp -p debian/$(p_gcj).overrides \
		$(d_gcj)/usr/share/lintian/overrides/$(p_gcj)
	cp -p $(srcdir)/gcc/java/ChangeLog \
		$(d_gcj)/usr/share/doc/$(p_jbase)/changelog.gcj
	cp -p $(srcdir)/libjava/ChangeLog \
		$(d_gcj)/usr/share/doc/$(p_jbase)/changelog.libjava

ifeq ($(with_standalone_gcj),yes)
	rm -f $(d)/$(PF)/$(libdir)/libgcc_s.so
	ln -sf /$(libdir)/libgcc_s.so.$(GCC_SONAME) $(d)/$(gcc_lib_dir)/libgcc_s.so
  ifeq ($(biarch),yes)
	rm -f $(d)/$(PF)/$(lib64)/libgcc_s.so
	dh_link -p$(p_gcc) \
	  /$(lib64)/libgcc_s.so.$(GCC_SONAME) /$(gcc_lib_dir)/libgcc_s_64.so \
	  /$(lib64)/libgcc_s.so.$(GCC_SONAME) /$(gcc_lib_dir)/64/libgcc_s.so
  endif
  ifeq ($(biarch32),yes)
	mkdir -p $(d_gcc)/$(gcc_lib_dir)
	mv $(d)/$(gcc_lib_dir)/32 $(d_gcc)/$(gcc_lib_dir)/
	dh_link -p$(p_gcc) \
	  /$(lib32)/libgcc_s.so.$(GCC_SONAME)  /$(gcc_lib_dir)/libgcc_s_32.so \
	  /$(lib32)/libgcc_s.so.$(GCC_SONAME)  /$(gcc_lib_dir)/32/libgcc_s_32.so \
	  /$(lib32)/libgcc_s.so.$(GCC_SONAME)  /$(gcc_lib_dir)/32/libgcc_s.so
  endif
endif
	DH_COMPAT=2 dh_movefiles -p$(p_gcj)  $(files_gcj)

	ln -sf gcj$(pkg_ver) \
	    $(d_gcj)/$(PF)/bin/$(TARGET_ALIAS)-gcj$(pkg_ver)
	ln -sf gcj$(pkg_ver).1 \
	    $(d_gcj)/$(PF)/share/man/man1/$(TARGET_ALIAS)-gcj$(pkg_ver).1
	ln -sf gcj$(pkg_ver) \
	    $(d_gcj)/$(PF)/bin/$(TARGET_ALIAS)-gcj$(pkg_ver)
	ln -sf gcj$(pkg_ver).1 \
	    $(d_gcj)/$(PF)/share/man/man1/$(TARGET_ALIAS)-gcj$(pkg_ver).1

	debian/dh_doclink -p$(p_gcj) $(p_jlib)
ifneq ($(GFDL_INVARIANT_FREE),yes)
	cp -p html/gcj.html $(d_gcj)/$(docdir)/$(p_jbase)/
endif
	cp -p debian/FAQ.gcj $(d_gcj)/$(docdir)/$(p_jbase)/

	cp -p debian/gcj-wrapper$(pkg_ver) $(d_gcj)/$(PF)/bin/
	chmod 755 $(d_gcj)/$(PF)/bin/gcj-wrapper$(pkg_ver)
	cp -p debian/gcj-wrapper$(pkg_ver).1 $(d_gcj)/$(PF)/share/man/man1/

	cp -p debian/gcjh-wrapper$(pkg_ver) $(d_gcj)/$(PF)/bin/
	chmod 755 $(d_gcj)/$(PF)/bin/gcjh-wrapper$(pkg_ver)
	cp -p debian/gcjh-wrapper$(pkg_ver).1 $(d_gcj)/$(PF)/share/man/man1/

	debian/dh_rmemptydirs -p$(p_gcj)

	dh_strip -p$(p_gcj)
	dh_compress -p$(p_gcj) -X.java
	dh_fixperms -p$(p_gcj)
	dh_shlibdeps -p$(p_gcj)
	dh_gencontrol -p$(p_gcj) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_gcj)
	dh_md5sums -p$(p_gcj)
	dh_builddeb -p$(p_gcj)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-libgcjdev: $(build_html_stamp) $(install_stamp) $(binary_stamp)-java
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	dh_installdirs -p$(p_jdev) $(dirs_jdev)

	DH_COMPAT=2 dh_movefiles -p$(p_jdev) $(files_jdev)

	debian/dh_doclink -p$(p_jdev) $(p_jbase)

	debian/dh_rmemptydirs -p$(p_jdev)

	dh_strip -p$(p_jdev) --dbg-package=$(p_jlib)
	dh_compress -p$(p_jdev) -X.java
	dh_fixperms -p$(p_jdev)
	dh_shlibdeps \
		-L$(p_lgcc) \
		-l:$(d)/$(PF)/$(libdir):$(d_lib)/$(PF)/$(libdir):$(d_jlib)/$(PF)/$(libdir):$(d_lgcc)/lib \
		-p$(p_jdev)
	dh_gencontrol -p$(p_jdev) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_jdev)
	dh_md5sums -p$(p_jdev)
	dh_builddeb -p$(p_jdev)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-libgcjdbg: $(install_stamp) $(binary_stamp)-java $(binary_stamp)-libgcjdev
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	debian/dh_doclink -p$(p_jdbg) $(p_jbase)

	for i in  libgij libgcj libgcjawt lib-gnu-java-awt-peer-gtk; do \
	  ln -sf $$i.so.$(GCJ_SONAME).0.0 \
	    $(d_jdbg)/usr/lib/debug/usr/lib/$$i.so.$(GCJ_SONAME); \
	done
	ln -sf libgjsmalsa.so.0.0.0 \
	  $(d_jdbg)/usr/lib/debug/usr/lib/libgjsmalsa.so.0

	dh_compress -p$(p_jdbg)
	dh_fixperms -p$(p_jdbg)
	dh_gencontrol -p$(p_jdbg) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_jdbg)
	dh_md5sums -p$(p_jdbg)
	dh_builddeb -p$(p_jdbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-java32: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	dh_installdirs -p$(p_j32lib) \
		usr/lib32
	dh_installdirs -p$(p_j32dev) \
		usr/lib32

	mv $(d)/$(lib32)/libg[ic]j.so.* \
		$(d_j32lib)/$(lib32)/.

	if [ -f debian/tmp/$(lib32)/libgcjawt.la ]; then \
	  mkdir -p $(d_j32lib)/$(lib32)/gcj$(pkg_ver); \
	  cp -p debian/tmp/$(lib32)/libgcjawt.la \
		debian/tmp/$(lib32)/lib-gnu-java-awt*.la \
		$(d_j32lib)/$(lib32)/gcj$(pkg_ver)/; \
	fi

# no static libs yet ...
	DH_COMPAT=2 dh_movefiles -p$(p_j32dev) \
	  $(lib32)/libgij*.{a,la,so} \
	  $(lib32)/libgcj*.{a,la,so}
#	dh_link -p $(p_j32dev) \
#	  $(PF)/lib32/libgcj.so.$(GCJ_SONAME) $(gcc_lib_dir)/32/libgcj.so \
#	  $(PF)/lib32/libgij.so.$(GCJ_SONAME) $(gcc_lib_dir)/32/libgij.so

	debian/dh_doclink -p$(p_j32lib) $(p_jbase)
	debian/dh_doclink -p$(p_j32dev) $(p_jbase)
	debian/dh_doclink -p$(p_j32dbg) $(p_jbase)

	DH_COMPAT=5 dh_strip -p$(p_j32lib) --dbg-package=$(p_j32dbg)

	for i in  libgij libgcj; do \
	  ln -sf $$i.so.$(GCJ_SONAME).0.0 \
	    $(d_j32dbg)/usr/lib/debug/usr/lib32/$$i.so.$(GCJ_SONAME); \
	done

	debian/dh_rmemptydirs -p$(p_j32lib)
	debian/dh_rmemptydirs -p$(p_j32dev)
	debian/dh_rmemptydirs -p$(p_j32dbg)

	dh_compress -p$(p_j32lib) -p$(p_j32dev) -p$(p_j32dbg)
	dh_fixperms -p$(p_j32lib) -p$(p_j32dev) -p$(p_j32dbg)
#	dh_shlibdeps -p$(p_j32lib) -p$(p_j32dev) -p$(p_j32dbg)
	dh_gencontrol -p$(p_j32lib) -p$(p_j32dev) -p$(p_j32dbg) \
		-- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_j32lib) -p$(p_j32dev) -p$(p_j32dbg)
	dh_md5sums -p$(p_j32lib) -p$(p_j32dev) -p$(p_j32dbg)
	dh_builddeb -p$(p_j32lib) -p$(p_j32dev) -p$(p_j32dbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

