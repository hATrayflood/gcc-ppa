ifeq ($(with_libcxx),yes)
  arch_binaries  := $(arch_binaries) libstdcxx
endif
ifeq ($(with_lib64cxx),yes)
  arch_binaries  := $(arch_binaries) lib64stdcxx
endif
ifeq ($(biarch_ia32),yes)
  arch_binaries	:= $(arch_binaries) lib32stdcxx
endif

ifeq ($(with_cxxdev),yes)
  arch_binaries  := $(arch_binaries) libstdcxx-dev
endif

p_lib	= libstdc++$(CXX_SONAME)$(cross_lib_arch)
p_dev	= $(p_lib:%$(cross_lib_arch)=%-dev$(cross_lib_arch))
p_pic	= $(p_lib:%$(cross_lib_arch)=%-pic$(cross_lib_arch))
p_dbg	= $(p_lib:%$(cross_lib_arch)=%-dbg$(cross_lib_arch))
p_lib64	= lib64stdc++$(CXX_SONAME)$(cross_lib_arch)
p_lib32	= lib32stdc++$(CXX_SONAME)$(cross_lib_arch)

d_lib	= debian/$(p_lib)
d_lib64	= debian/$(p_lib64)
d_lib32	= debian/$(p_lib32)
d_dev	= debian/$(p_dev)
d_pic	= debian/$(p_pic)
d_dbg	= debian/$(p_dbg)

dirs_lib = \
	$(docdir) \
	$(PF)/$(DEB_TARGET_GNU_TYPE)/lib

dirs_lib64 = \
	$(docdir) \
	$(PF)/$(DEB_TARGET_GNU_TYPE)/lib64

files_lib = \
	$(PF)/$(DEB_TARGET_GNU_TYPE)/lib/libstdc++.so.*

files_lib64 = \
	$(PF)/$(DEB_TARGET_GNU_TYPE)/lib64/libstdc++.so.*

dirs_dev = \
	$(docdir)/$(p_lib) \
	$(PF)/$(DEB_TARGET_GNU_TYPE)/lib \
	$(gcc_lib_dir)/include \
	$(cxx_inc_dir)

files_dev = \
	$(cxx_inc_dir)/ \
	$(gcc_lib_dir)/libstdc++.{a,so} \
	$(gcc_lib_dir)/libsupc++.a
# Not yet...
#	$(PF)/$(libdir)/lib{supc,stdc}++.la

dirs_dbg = \
	$(docdir) \
	$(PF)/$(DEB_TARGET_GNU_TYPE)/lib/debug \
	$(gcc_lib_dir)
files_dbg = \
	$(PF)/$(DEB_TARGET_GNU_TYPE)/lib/debug/libstdc++.*

dirs_pic = \
	$(docdir) \
	$(gcc_lib_dir)
files_pic = \
	$(gcc_lib_dir)/libstdc++_pic.a

ifeq ($(with_lib64cxx),yes)
    dirs_dev += $(gcc_lib_dir)/64/
    files_dev += $(gcc_lib_dir)/64/libstdc++.{a,so} \
        $(gcc_lib_dir)/64/libsupc++.a
    dirs_dbg += $(PF)/$(DEB_TARGET_GNU_TYPE)/lib64/debug
    files_dbg += $(PF)/$(DEB_TARGET_GNU_TYPE)/lib64/debug/libstdc++.*
    dirs_pic += $(gcc_lib_dir)
    files_pic += $(gcc_lib_dir)/64/libstdc++_pic.a
endif

# ----------------------------------------------------------------------

$(binary_stamp)-libstdcxx: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_lib)
	dh_installdirs -p$(p_lib) $(dirs_lib)
	DH_COMPAT=2 dh_movefiles -p$(p_lib) $(files_lib)

	dh_installdocs -p$(p_lib)
	echo "See /$(docdir)/$(p_base) for more information" \
		> $(d_lib)/$(docdir)/$(p_lib)/README.Debian

	dh_installchangelogs -p$(p_lib)
	debian/dh_rmemptydirs -p$(p_lib)

	PATH=/usr/share/dpkg-cross:$$PATH dh_strip -p$(p_lib)
	dh_compress -p$(p_lib)
	dh_fixperms -p$(p_lib)
	dh_makeshlibs -p$(p_lib) -V '$(p_lib) (>= $(DEB_STDCXX_SOVERSION))' -n
	sed s/$(cross_lib_arch)//g < debian/$(p_lib)/DEBIAN/shlibs > debian/$(p_lib)/DEBIAN/shlibs.fixed
	mv debian/$(p_lib)/DEBIAN/shlibs.fixed debian/$(p_lib)/DEBIAN/shlibs
	ARCH=$(DEB_TARGET_ARCH) MAKEFLAGS="CC=something" dh_shlibdeps -p$(p_lib)
	sed s/$(cross_lib_arch)//g < debian/$(p_lib).substvars > debian/$(p_lib).substvars.fixed
	mv debian/$(p_lib).substvars.fixed debian/$(p_lib).substvars
	sed 's/\(lib[^ ]*\) /\1$(cross_lib_arch) /g' < debian/$(p_lib).substvars > debian/$(p_lib).substvars.new
	mv debian/$(p_lib).substvars.new debian/$(p_lib).substvars
	dh_gencontrol -p$(p_lib) -- -v$(DEB_VERSION) $(common_substvars)

	dh_installdeb -p$(p_lib)
	dh_md5sums -p$(p_lib)
	dh_builddeb -p$(p_lib)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------

$(binary_stamp)-lib64stdcxx: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_lib64)
	dh_installdirs -p$(p_lib64) $(dirs_lib64)
	DH_COMPAT=2 dh_movefiles -p$(p_lib64) $(files_lib64)

	dh_installdocs -p$(p_lib64)
	echo "See /$(docdir)/$(p_base) for more information" \
		> $(d_lib64)/$(docdir)/$(p_lib64)/README.Debian

	dh_installchangelogs -p$(p_lib64)
	debian/dh_rmemptydirs -p$(p_lib64)

	PATH=/usr/share/dpkg-cross:$$PATH dh_strip -p$(p_lib64)
	dh_compress -p$(p_lib64)
	dh_fixperms -p$(p_lib64)
	dh_makeshlibs -p$(p_lib64) -V '$(p_lib64) (>= $(DEB_STDCXX_SOVERSION))' -n
	sed s/$(cross_lib_arch)//g < debian/$(p_lib64)/DEBIAN/shlibs > debian/$(p_lib64)/DEBIAN/shlibs.fixed
	mv debian/$(p_lib64)/DEBIAN/shlibs.fixed debian/$(p_lib64)/DEBIAN/shlibs
	ARCH=$(DEB_TARGET_ARCH) MAKEFLAGS="CC=something" dh_shlibdeps -p$(p_lib64)
	sed s/$(cross_lib_arch)//g < debian/$(p_lib64).substvars > debian/$(p_lib64).substvars.fixed
	mv debian/$(p_lib64).substvars.fixed debian/$(p_lib64).substvars
	sed 's/\(lib[^ ]*\) /\1$(cross_lib_arch) /g' < debian/$(p_lib64).substvars > debian/$(p_lib64).substvars.new
	mv debian/$(p_lib64).substvars.new debian/$(p_lib64).substvars
	dh_gencontrol -p$(p_lib64) -- -v$(DEB_VERSION) $(common_substvars)

	dh_installdeb -p$(p_lib64)
	dh_md5sums -p$(p_lib64)
	dh_builddeb -p$(p_lib64)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------

$(binary_stamp)-lib32stdcxx: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_lib32)
	dh_installdirs -p$(p_lib32) $(dirs_lib32)
	DH_COMPAT=2 dh_movefiles -p$(p_lib32) $(files_lib32)

	dh_installdocs -p$(p_lib32)
	echo "See /$(docdir)/$(p_base) for more information" \
		> $(d_lib32)/$(docdir)/$(p_lib32)/README.Debian

	dh_installchangelogs -p$(p_lib32)
	debian/dh_rmemptydirs -p$(p_lib32)

	PATH=/usr/share/dpkg-cross:$$PATH dh_strip -p$(p_lib32)
	dh_compress -p$(p_lib32)
	dh_fixperms -p$(p_lib32)
	dh_makeshlibs -p$(p_lib32) -V '$(p_lib32) (>= $(DEB_STDCXX_SOVERSION))' -n
	sed s/$(cross_lib_arch)//g < debian/$(p_lib32)/DEBIAN/shlibs > debian/$(p_lib32)/DEBIAN/shlibs.fixed
	mv debian/$(p_lib32)/DEBIAN/shlibs.fixed debian/$(p_lib32)/DEBIAN/shlibs
	ARCH=$(DEB_TARGET_ARCH) MAKEFLAGS="CC=something" dh_shlibdeps -p$(p_lib32)
	sed s/$(cross_lib_arch)//g < debian/$(p_lib32).substvars > debian/$(p_lib32).substvars.fixed
	mv debian/$(p_lib32).substvars.fixed debian/$(p_lib32).substvars
	sed 's/\(lib[^ ]*\) /\1$(cross_lib_arch) /g' < debian/$(p_lib32).substvars > debian/$(p_lib32).substvars.new
	mv debian/$(p_lib32).substvars.new debian/$(p_lib32).substvars
	dh_gencontrol -p$(p_lib32) -- -v$(DEB_VERSION) $(common_substvars)

	dh_installdeb -p$(p_lib32)
	dh_md5sums -p$(p_lib32)
	dh_builddeb -p$(p_lib32)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)

# ----------------------------------------------------------------------
$(binary_stamp)-libstdcxx-dev: $(install_stamp) \
    $(binary_stamp)-libstdcxx
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_dev) $(d_pic)
	dh_installdirs -p$(p_dev) $(dirs_dev)
	dh_installdirs -p$(p_pic) $(dirs_pic)
	dh_installdirs -p$(p_dbg) $(dirs_dbg)

	: # - correct libstdc++-v3 file locations
	mv $(d)/$(PF)/$(DEB_TARGET_GNU_TYPE)/lib/libsupc++.a $(d)/$(gcc_lib_dir)/
	mv $(d)/$(PF)/$(DEB_TARGET_GNU_TYPE)/lib/libstdc++.{a,so} $(d)/$(gcc_lib_dir)/
	ln -sf ../../../../$(DEB_TARGET_GNU_TYPE)/lib/libstdc++.so.$(CXX_SONAME) $(d)/$(gcc_lib_dir)/libstdc++.so
	mv $(d)/$(PF)/$(DEB_TARGET_GNU_TYPE)/lib/libstdc++_pic.a \
		$(d)/$(gcc_lib_dir)/

	rm -f $(d)/$(PF)/$(DEB_TARGET_GNU_TYPE)/lib/debug/libstdc++_pic.a
	rm -f $(d)/$(PF)/$(DEB_TARGET_GNU_TYPE)/lib64/debug/libstdc++_pic.a

	: # remove precompiled headers
	-find $(d) -type d -name '*.gch' | xargs rm -rf

ifeq ($(with_lib64cxx),yes)
	mv $(d)/$(PF)/$(DEB_TARGET_GNU_TYPE)/lib64/lib*c++*.a $(d)/$(gcc_lib_dir)/64/.
	ln -sf ../../../../../lib64/libstdc++.so.$(CXX_SONAME) \
		$(d)/$(gcc_lib_dir)/64/libstdc++.so
endif

	DH_COMPAT=2 dh_movefiles -p$(p_dev) $(files_dev)
	DH_COMPAT=2 dh_movefiles -p$(p_pic) $(files_pic)
	DH_COMPAT=2 dh_movefiles -p$(p_dbg) $(files_dbg)

	debian/dh_doclink -p$(p_dev) $(p_lib)
	debian/dh_doclink -p$(p_pic) $(p_lib)
	debian/dh_doclink -p$(p_dbg) $(p_lib)
	cp -p $(srcdir)/libstdc++-v3/ChangeLog \
		$(d_dev)/usr/share/doc/$(p_lib)/changelog
	cp -p $(srcdir)/libstdc++-v3/config/linker-map.gnu \
		$(d_pic)/$(gcc_lib_dir)/libstdc++_pic.map

ifeq ($(with_cxxdev),yes)
	debian/dh_rmemptydirs -p$(p_dev)
	debian/dh_rmemptydirs -p$(p_pic)
	debian/dh_rmemptydirs -p$(p_dbg)
endif

	PATH=/usr/share/dpkg-cross:$$PATH dh_strip -p$(p_dev) -p$(p_pic)
	dh_compress -p$(p_dev) -p$(p_pic) -p$(p_dbg) -X.txt
	dh_fixperms -p$(p_dev) -p$(p_pic) -p$(p_dbg)
	dh_gencontrol -p$(p_dev) -p$(p_pic) -p$(p_dbg) \
		-- -v$(DEB_VERSION) $(common_substvars)

	dh_installdeb -p$(p_dev) -p$(p_pic) -p$(p_dbg)
	dh_md5sums -p$(p_dev) -p$(p_pic) -p$(p_dbg)
	dh_builddeb -p$(p_dev) -p$(p_pic) -p$(p_dbg)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
