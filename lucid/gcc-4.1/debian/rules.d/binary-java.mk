ifeq ($(with_separate_libgcj),yes)
  ifeq ($(PKGSOURCE),gcj-$(BASE_VERSION))
    arch_binaries  := $(arch_binaries) jbase
  endif
else
  arch_binaries  := $(arch_binaries) jbase
endif

ifeq ($(with_libgcj),yes)
  ifeq ($(with_java),yes)
    arch_binaries  := $(arch_binaries) java gcjapplet
    indep_binaries  := $(indep_binaries) libgcjjar
  endif

  ifeq ($(with_javadev),yes)
    arch_binaries  := $(arch_binaries) libgcjdev libgcjdbg
    indep_binaries := $(indep_binaries) libgcjsrc
    ifeq ($(with_libgcj_doc),yes)
      indep_binaries := $(indep_binaries) libgcjdoc
    endif
  endif
endif

ifeq ($(with_gcj),yes)
    arch_binaries  := $(arch_binaries) gcj
endif

p_jbase	= gcj$(pkg_ver)-base
p_gcj	= gcj$(pkg_ver)
p_gij	= gij$(pkg_ver)
p_jlib	= libgcj$(PKG_LIBGCJ_EXT)
p_jdbg	= libgcj$(PKG_GCJ_EXT)-dbg
p_jar	= libgcj$(PKG_GCJ_EXT)-jar
p_jlibx	= libgcj$(PKG_LIBGCJ_EXT)-awt
p_jdev	= libgcj$(PKG_GCJ_EXT)-dev
p_jsrc	= libgcj$(PKG_GCJ_EXT)-src
p_view	= gappletviewer$(pkg_ver)
p_plug	= gcjwebplugin$(pkg_ver)
p_jdoc	= libgcj-doc

d_jbase	= debian/$(p_jbase)
d_gcj	= debian/$(p_gcj)
d_gij	= debian/$(p_gij)
d_jlib	= debian/$(p_jlib)
d_jdbg	= debian/$(p_jdbg)
d_jar	= debian/$(p_jar)
d_jlibx	= debian/$(p_jlibx)
d_jdev	= debian/$(p_jdev)
d_jsrc	= debian/$(p_jsrc)
d_jdoc	= debian/$(p_jdoc)
d_view	= debian/$(p_view)
d_plug	= debian/$(p_plug)

gcj_vlibdir	= $(PF)/$(libdir)/gcj-$(BASE_VERSION)-$(GCJ_SONAME)

dirs_gcj = \
	$(docdir)/$(p_jbase) \
	$(PF)/bin \
	$(PF)/share/man/man1 \
	$(PF)/share/info \
	$(gcc_lexec_dir)
files_gcj = \
	$(PF)/bin/{gcj,gjar,gjarsigner,gcjh,gjavah,gnative2ascii,grmic,gtnameserv,jv-convert,jcf-dump}$(pkg_ver) \
	$(PF)/share/man/man1/{gjar,gjarsigner,gcjh,gjavah,gnative2ascii,grmic,gtnameserv}$(pkg_ver).1 \
	$(gcc_lexec_dir)/{ecj1,jc1,jvgenmain}

ifneq ($(GFDL_INVARIANT_FREE),yes)
  files_gcj += \
	$(PF)/share/info/gcj* \
	$(PF)/share/man/man1/{gcj,jv-convert,jcf-dump}$(pkg_ver).1
endif

dirs_gij = \
	$(docdir)/$(p_jbase) \
	$(PF)/bin \
	$(PF)/share/man/man1 \
	var/lib/gcj$(pkg_ver)

files_gij = \
	$(PF)/bin/{gij,gcj-dbtool,gorbd,grmid,grmiregistry,gkeytool,gserialver}$(pkg_ver) \
	$(PF)/share/man/man1/{gorbd,grmid,grmiregistry,gkeytool,gserialver}$(pkg_ver).1

ifneq ($(GFDL_INVARIANT_FREE),yes)
  files_gij += \
	$(PF)/share/man/man1/{gij,gcj-dbtool}$(pkg_ver).1
endif

dirs_jlib = \
	$(docdir)/$(p_jbase) \
	$(gcj_vlibdir) \
	$(PF)/$(libdir)

files_jlib = \
	$(PF)/$(libdir)/libgij.so.* \
	$(PF)/$(libdir)/libgcj-tools.so.* \
	$(PF)/$(libdir)/libgcj.so.* \
	$(gcj_vlibdir)/libjvm.so \

#	$(gcj_vlibdir)/libgconfpeer.so

ifeq ($(with_java_alsa),yes)
  files_jlib += \
	$(gcj_vlibdir)/libgjsmalsa.so
endif

dirs_jar = \
	$(PF)/share/java

dirs_jlibx = \
	$(PF)/$(libdir) \
	$(gcj_vlibdir) \
	$(PF)/share/java

files_jlibx = \
	$(gcj_vlibdir)/libjawt.so \
	$(gcj_vlibdir)/libgtkpeer.so

dirs_jdev = \
	$(docdir)/$(p_jbase)/examples \
	$(PF)/{include,lib} \
	$(gcc_lib_dir)/include/gcj

files_jdev = \
	$(cxx_inc_dir)/{org,gcj,java,javax} \
	$(cxx_inc_dir)/gnu/{awt,classpath,gcj,java,javax} \
	$(gcc_lib_dir)/include/{jni.h,jni_md.h,jvmpi.h} \
	$(gcc_lib_dir)/include/{jawt.h,jawt_md.h} \
	$(gcc_lib_dir)/include/gcj/libgcj-config.h \
	$(PF)/$(libdir)/libgij.so \
	$(PF)/$(libdir)/libgcj.{so,spec} \
	$(PF)/$(libdir)/libgcj-tools.so \
	$(PF)/$(libdir)/pkgconfig/libgcj-$(BASE_VERSION).pc

ifeq ($(with_static_java),yes)
  files_jdev += \
	$(PF)/$(libdir)/libgij.a \
	$(PF)/$(libdir)/libgcj.a \
	$(PF)/$(libdir)/libgcj-tools.a
endif

ifeq ($(with_standalone_gcj),yes)

  dirs_gcj += \
	$(gcc_lib_dir)/include \
	$(PF)/share/man/man1

  files_gcj += \
	$(PF)/bin/{cpp,gcc,gcov}$(pkg_ver) \
	$(gcc_lexec_dir)/cc1 \
	$(gcc_lexec_dir)/collect2 \
	$(gcc_lib_dir)/{libgcc*,libgcov.a,*.o} \
	$(gcc_lib_dir)/include/README \
	$(gcc_lib_dir)/include/{float,iso646,limits,std*,syslimits,unwind,varargs}.h \
	$(shell for d in asm bits gnu linux; do \
		  test -e $(d)/$(gcc_lib_dir)/include/$$d \
		    && echo $(gcc_lib_dir)/include/$$d; \
		done) \
	$(shell test -e $(d)/$(gcc_lib_dir)/SYSCALLS.c.X \
		&& echo $(gcc_lib_dir)/SYSCALLS.c.X) \
	$(shell for h in {,e,p,x}mmintrin.h mm3dnow.h mm_malloc.h; do \
		  test -e $(d)/$(gcc_lib_dir)/include/$$h \
		    && echo $(gcc_lib_dir)/include/$$h; \
		done) \

  ifneq ($(GFDL_INVARIANT_FREE),yes)
    files_gcj += \
	$(PF)/share/man/man1/{cpp,gcc,gcov}$(pkg_ver).1
  endif

  ifeq ($(biarch),yes)
    files_gcj += $(gcc_lib_dir)/$(biarchsubdir)/{libgcc*,libgcov.a,*.o}
  endif
  ifeq ($(biarch32),yes)
    files_gcj += $(gcc_lib_dir)/$(biarchsubdir)/{libgcc*,*.o}
  endif

  ifeq ($(DEB_HOST_ARCH),ia64)
    files_gcj += $(gcc_lib_dir)/include/ia64intrin.h
  endif

  ifeq ($(DEB_HOST_ARCH),m68k)
    files_gcj += $(gcc_lib_dir)/include/math-68881.h
  endif

  ifeq ($(DEB_TARGET_ARCH),$(findstring $(DEB_TARGET_ARCH),powerpc ppc64))
    files_gcj += $(gcc_lib_dir)/include/{altivec.h,ppc-asm.h,spe.h}
  endif

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
$(binary_stamp)-libgcjjar: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	dh_installdirs -p$(p_jar) $(dirs_jar)
	mv $(d)/$(PF)/share/java/libgcj-$(BASE_VERSION).jar \
		$(d_jar)/$(PF)/share/java/
	mv $(d)/$(PF)/share/java/libgcj-tools-$(BASE_VERSION).jar \
		$(d_jar)/$(PF)/share/java/

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
	mv $(d)/$(PF)/share/java/src-$(BASE_VERSION).zip \
	   $(d_jsrc)/$(PF)/share/java/libgcj-src-$(BASE_VERSION).zip

	: #  add files for the classpath examples
	cd $(srcdir)/libjava/classpath/examples && \
	  find ! -type d ! -name 'Makefile.??' ! -name '*.java' \
	  | $(builddir)/fastjar/fastjar -uvfM@ \
		$(PWD)/$(d_jsrc)/$(PF)/share/java/libgcj-src-$(BASE_VERSION).zip

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
libgcj_version = $(shell $(builddir)/gcc/xgcc --version \
			 | sed -n '/GCC/s/.*(GCC) *//p')
libgcj_title = LibGCJ Classpath
libgcjhbox_href = http://gcc.gnu.org/java
libgcjhbox = <span class='logo'><a href='$(libgcjhbox_href)' target='_top'>$(title)</a> ($(libgcj_version))

$(build_javadoc_stamp): $(build_stamp)
	mkdir -p $(builddir)/java-src
	cd $(builddir)/java-src && $(builddir)/fastjar/fastjar -xf \
		$(buildlibdir)/libjava/src.zip

	mkdir -p $(builddir)/html
	gjdoc \
	  -use \
	  -sourcepath "$(builddir)/java-src" \
	  -encoding UTF-8 \
	  -breakiterator \
	  -licensetext \
	  -linksource \
	  -splitindex \
	  -d $(builddir)/html \
	  -doctitle "$(title) $(libgcj_version)" \
	  -windowtitle "$(title) $(libgcj_version) Documentation" \
	  -header "$(classpathbox)" \
	  -footer "$(classpathbox)" \
	  -subpackages gnu:java:javax:org

	$(MAKE) -C $(buildlibdir)/libjava/classpath/examples

	touch $@


$(binary_stamp)-libgcjdoc: $(install_stamp) #$(build_javadoc_stamp)
	dh_testdir
	dh_testroot

	$(MAKE) -C $(buildlibdir)/libjava/classpath/examples \
	    GLIBJ_CLASSPATH="$(buildlibdir)/libjava/libgcj-$(BASE_VERSION).jar:$(buildlibdir)/libjava/libgcj-tools-$(BASE_VERSION).jar" \
	    DESTDIR=$(PWD)/$(d_jdoc) \
	    pkgdatadir=/usr/share/doc/$(p_jbase) \
		install

	dh_installdocs -p$(p_jdoc)
	dh_installchangelogs -p$(p_jdoc)
	mkdir -p $(d_jdoc)/usr/share/doc/$(p_jbase)
#	cp -al $(builddir)/html $(d_jdoc)/usr/share/doc/$(p_jbase)/
#	ln -sf ../$(p_jbase)/html $(d_jdoc)/usr/share/doc/$(p_jdoc)/html
	dh_compress -p$(p_jdoc) -X.java -X.c
	dh_fixperms -p$(p_jdoc)
	dh_gencontrol -p$(p_jdoc) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_jdoc)
	dh_md5sums -p$(p_jdoc)
	dh_builddeb -p$(p_jdoc)

	touch $@

# ----------------------------------------------------------------------
$(binary_stamp)-java: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	if [ -d $(d)/$(PF)/$(libdir)/gcj-$(GCC_VERSION) ]; then \
	  ls -l $(d)/$(PF)/$(libdir)/gcj-$(GCC_VERSION); \
	  mv $(d)/$(PF)/$(libdir)/gcj-$(GCC_VERSION)/* $(d)/$(gcj_vlibdir)/; \
	fi

	dh_installdirs -p$(p_gij)   $(dirs_gij)
	dh_installdirs -p$(p_jlib)  $(dirs_jlib)
	dh_installdirs -p$(p_jlibx) $(dirs_jlibx)

	DH_COMPAT=2 dh_movefiles -p$(p_gij)   $(files_gij)
	DH_COMPAT=2 dh_movefiles -p$(p_jlib)  $(files_jlib)
	DH_COMPAT=2 dh_movefiles -p$(p_jlibx) $(files_jlibx)

ifeq ($(DEB_HOST_ARCH),hppa)
	mv $(d_gij)/$(PF)/bin/gij$(pkg_ver) \
		$(d_gij)/$(PF)/bin/gij$(pkg_ver).bin
	install -m755 debian/gij-hppa $(d_gij)/$(PF)/bin/gij$(pkg_ver)
endif

	ln -s ../libgcj.so.$(GCJ_SONAME) \
		$(d_jlib)/$(gcj_vlibdir)/libgcj_bc.so.1

	cp -p $(srcdir)/libjava/{NEWS,README,THANKS} \
		$(d_gij)/usr/share/doc/$(p_jbase)/

	debian/dh_doclink -p$(p_gij)   $(p_jbase)
	debian/dh_doclink -p$(p_jlib)  $(p_jbase)
	debian/dh_doclink -p$(p_jlibx) $(p_jbase)

ifeq ($(with_separate_libgcj),yes)
  ifeq ($(PKGSOURCE),gcj-$(BASE_VERSION))
    ifeq ($(with_check),yes)
	cp -p test-summary $(d_gij)/usr/share/doc/$(p_jbase)/test-summary
    endif
  endif
endif
	debian/dh_rmemptydirs -p$(p_gij)
	debian/dh_rmemptydirs -p$(p_jlib)
	debian/dh_rmemptydirs -p$(p_jlibx)

	mkdir -p $(d_gij)/var/lib/gcj$(pkg_ver)

	dh_makeshlibs -p$(p_jlib) -V '$(p_jlib) (>= $(DEB_GCJ_SOVERSION))'
	echo "libgcj_bc 1 libgcj-bc (>= 4.1.2-1)" >> debian/$(p_jlib)/DEBIAN/shlibs
	cat debian/$(p_jlib)/DEBIAN/shlibs >> debian/shlibs.local

	dh_makeshlibs -p$(p_jlibx) -V '$(p_jlibx) (>= $(DEB_GCJ_SOVERSION))'

	-cd $(d_jlibx)/$(PF)/lib/gcj$(pkg_ver) \
	  && ldd libjawt.so libgtkpeer.so
	DH_COMPAT=5 dh_strip \
		-p$(p_gij) -p$(p_jlib) -p$(p_jlibx) --dbg-package=$(p_jdbg)
	-cd $(d_jlibx)/$(PF)/lib/gcj$(pkg_ver) \
	  && ldd libjawt.so libgtkpeer.so

	dh_compress -p$(p_gij) -p$(p_jlib) -p$(p_jlibx)
	dh_fixperms -p$(p_gij) -p$(p_jlib) -p$(p_jlibx)
# the libstdc++ binary packages aren't built yet ...
	echo 'libstdc++ $(CXX_SONAME) libstdc++$(CXX_SONAME) (>= $(DEB_STDCXX_SOVERSION))' \
	    >> debian/shlibs.local
	dh_shlibdeps \
		-L$(p_jlib) \
		-l$(d_lib)/$(PF)/$(libdir):$(d_jlib)/$(PF)/$(libdir) \
		-p$(p_gij) -p$(p_jlib) -p$(p_jlibx)
	sed -e 's/$(p_jlib)[^,]*//' -e 's/, *,/,/' debian/$(p_jlib).substvars \
		>> debian/$(p_jlib).substvars.tmp \
	    && mv -f debian/$(p_jlib).substvars.tmp debian/$(p_jlib).substvars
	dh_gencontrol \
		-p$(p_gij) -p$(p_jlib) -p$(p_jlibx) \
		-- -v$(DEB_VERSION) $(common_substvars)

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
endif
	DH_COMPAT=2 dh_movefiles -p$(p_gcj)  $(files_gcj)

	ln -sf gcj$(pkg_ver) \
	    $(d_gcj)/$(PF)/bin/$(TARGET_ALIAS)-gcj$(pkg_ver)

ifneq ($(GFDL_INVARIANT_FREE),yes)
	ln -sf gcj$(pkg_ver).1 \
	    $(d_gcj)/$(PF)/share/man/man1/$(TARGET_ALIAS)-gcj$(pkg_ver).1
	cp -p html/gcj.html $(d_gcj)/$(docdir)/$(p_jbase)/
endif
	debian/dh_doclink -p$(p_gcj) $(p_jbase)

	cp -p debian/FAQ.gcj $(d_gcj)/$(docdir)/$(p_jbase)/

	cp -p debian/gcj-wrapper$(pkg_ver) $(d_gcj)/$(PF)/bin/
	chmod 755 $(d_gcj)/$(PF)/bin/gcj-wrapper$(pkg_ver)
	cp -p debian/gcj-wrapper$(pkg_ver).1 $(d_gcj)/$(PF)/share/man/man1/

	debian/dh_rmemptydirs -p$(p_gcj)

	dh_strip -p$(p_gcj)
	dh_compress -p$(p_gcj) -X.java
	dh_fixperms -p$(p_gcj)
	: # FIXME: remove it temporarily, insane dpkg-shlibdeps
	rm -f $(d_jlib)/$(gcj_vlibdir)/libgcj_bc.so.1
	dh_shlibdeps -p$(p_gcj) -l$(d_jlib)/$(PF)/lib -L$(p_jlib)
	ln -s ../libgcj.so.$(GCJ_SONAME) \
		$(d_jlib)/$(gcj_vlibdir)/libgcj_bc.so.1
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

	for i in libgij libgcj libgcj-tools; do \
	  dh_link -p$(p_jdev) /$(PF)/$(libdir)/$$i.so.$(GCJ_SONAME) \
	    $(gcc_lib_dir)/$$i.so; \
	  rm -f $(d_jdev)/$(PF)/$(libdir)/$$i.{la,so}; \
	done
ifeq ($(with_static_java),yes)
	for i in libgij libgcj libgcj-tools; do \
	  mv $(d_jdev)/$(PF)/$(libdir)/$$i.a $(d_jdev)/$(gcc_lib_dir)/; \
	done
endif

	ln -sf libgcj-$(BASE_VERSION).pc \
		$(d_jdev)/$(PF)/$(libdir)/pkgconfig/libgcj$(PKG_GCJ_EXT).pc

	mv $(d_jdev)/$(PF)/$(libdir)/libgcj.spec $(d_jdev)/$(gcc_lib_dir)/

	install -m 755 $(d)/$(PF)/lib/libgcj_bc.so.1 \
		$(d_jdev)/$(gcc_lib_dir)/libgcj_bc.so

	debian/dh_doclink -p$(p_jdev) $(p_jbase)

	debian/dh_rmemptydirs -p$(p_jdev)

	mkdir -p $(d_jdev)/usr/share/lintian/overrides
	cp -p debian/$(p_jdev).overrides \
		$(d_jdev)/usr/share/lintian/overrides/$(p_jdev)

	DH_COMPAT=5 dh_strip -p$(p_jdev) --dbg-package=$(p_jdbg)
	dh_compress -p$(p_jdev) -X.java
	dh_fixperms -p$(p_jdev)
	dh_shlibdeps \
		-l$(d_lib)/$(PF)/$(libdir):$(d_jlib)/$(PF)/$(libdir) \
		-p$(p_jdev)
	dh_gencontrol -p$(p_jdev) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_jdev)
	dh_md5sums -p$(p_jdev)
	dh_builddeb -p$(p_jdev)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-libgcjdbg: $(install_stamp) $(binary_stamp)-java $(binary_stamp)-libgcjdev $(binary_stamp)-gcjapplet
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	debian/dh_doclink -p$(p_jdbg) $(p_jbase)

	for i in libgij libgcj libgcj-tools; do \
	  if [ -f $(d_jdbg)/usr/lib/debug/usr/lib/$$i.so.$(GCJ_SONAME).0.0 ]; then \
	    ln -sf $$i.so.$(GCJ_SONAME).0.0 \
	      $(d_jdbg)/usr/lib/debug/usr/lib/$$i.so.$(GCJ_SONAME); \
	  fi; \
	done

	dh_compress -p$(p_jdbg)
	dh_fixperms -p$(p_jdbg)
	dh_gencontrol -p$(p_jdbg) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_jdbg)
	dh_md5sums -p$(p_jdbg)
	dh_builddeb -p$(p_jdbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-gcjapplet: $(install_stamp) $(binary_stamp)-java
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	dh_installdirs -p$(p_view) \
		$(PF)/bin \
		$(PF)/share/man/man1
	DH_COMPAT=2 dh_movefiles -p$(p_view) \
		$(PF)/bin/gappletviewer$(pkg_ver) \
		$(PF)/share/man/man1/gappletviewer$(pkg_ver).1

ifeq ($(with_pkg_plugin),yes)
	dh_installdirs -p$(p_plug) \
		$(gcj_vlibdir) \
		$(foreach d, $(browser_plugin_dirs), usr/lib/$(d)/plugins)
	DH_COMPAT=2 dh_movefiles -p$(p_plug) \
		$(gcj_vlibdir)/libgcjwebplugin.so
else
	DH_COMPAT=2 dh_movefiles -p$(p_view) \
		$(gcj_vlibdir)/libgcjwebplugin.so
endif
	rm -f $(d)/$(gcj_vlibdir)/libgcjwebplugin.*a

	debian/dh_doclink -p$(p_view) $(p_jbase)

	DH_COMPAT=5 dh_strip -p$(p_view) --dbg-package=$(p_jdbg)
	dh_compress -p$(p_view)
	dh_fixperms -p$(p_view)
	dh_gencontrol -p$(p_view) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_view)
	dh_md5sums -p$(p_view)
	dh_builddeb -p$(p_view)

ifeq ($(with_pkg_plugin),yes)
	debian/dh_doclink -p$(p_plug) $(p_jbase)

	DH_COMPAT=5 dh_strip -p$(p_plug) --dbg-package=$(p_jdbg)
	dh_compress -p$(p_plug)
	dh_fixperms -p$(p_plug)
	dh_gencontrol -p$(p_plug) -- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_plug)
	dh_md5sums -p$(p_plug)
	dh_builddeb -p$(p_plug)
endif

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
